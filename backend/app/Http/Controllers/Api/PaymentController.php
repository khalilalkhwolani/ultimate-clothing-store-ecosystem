<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\GetPaymentIntentRequest;
use App\Http\Requests\WebhookRequest;
use App\Models\Order;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;
use Stripe\Event;
use Stripe\PaymentIntent;
use Stripe\Stripe;
use Stripe\Webhook;

class PaymentController extends Controller
{
    /**
     * Handle Stripe webhook for payment events.
     */
    public function webhook(WebhookRequest $request): JsonResponse
    {
        $payload = $request->getContent();
        $sigHeader = $request->header('Stripe-Signature');
        $endpointSecret = config('services.stripe.webhook_secret');

        try {
            $event = Webhook::constructEvent($payload, $sigHeader, $endpointSecret);
        } catch (\UnexpectedValueException $e) {
            Log::error('Invalid payload', ['error' => $e->getMessage()]);
            return response()->json(['error' => 'Invalid payload'], 400);
        } catch (\Stripe\Exception\SignatureVerificationException $e) {
            Log::error('Invalid signature', ['error' => $e->getMessage()]);
            return response()->json(['error' => 'Invalid signature'], 400);
        }

        // Handle the event
        switch ($event->type) {
            case 'payment_intent.succeeded':
                $paymentIntent = $event->data->object;
                $this->handlePaymentSucceeded($paymentIntent);
                break;
            case 'payment_intent.payment_failed':
                $paymentIntent = $event->data->object;
                $this->handlePaymentFailed($paymentIntent);
                break;
            default:
                Log::info('Unhandled event type', ['type' => $event->type]);
        }

        return response()->json(['status' => 'success']);
    }

    /**
     * Get payment intent status.
     */
    public function getPaymentIntent(GetPaymentIntentRequest $request, $id): JsonResponse
    {
        Stripe::setApiKey(config('services.stripe.secret'));

        try {
            $paymentIntent = PaymentIntent::retrieve($id);
            return response()->json([
                'id' => $paymentIntent->id,
                'status' => $paymentIntent->status,
                'amount' => $paymentIntent->amount,
                'currency' => $paymentIntent->currency,
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Payment intent not found'], 404);
        }
    }

    /**
     * Handle successful payment.
     */
    private function handlePaymentSucceeded($paymentIntent)
    {
        $orderId = $paymentIntent->metadata['order_id'] ?? null;

        if ($orderId) {
            $order = Order::find($orderId);
            if ($order) {
                $order->update([
                    'payment_status' => 'paid',
                    'status' => 'processing', // or 'confirmed'
                ]);

                // Update inventory
                foreach ($order->orderItems as $item) {
                    $variant = $item->productVariant;
                    if ($variant) {
                        $variant->decrement('stock', $item->quantity);
                    }
                }

                Log::info('Order payment succeeded', ['order_id' => $orderId]);
            }
        }
    }

    /**
     * Handle failed payment.
     */
    private function handlePaymentFailed($paymentIntent)
    {
        $orderId = $paymentIntent->metadata['order_id'] ?? null;

        if ($orderId) {
            $order = Order::find($orderId);
            if ($order) {
                $order->update([
                    'payment_status' => 'failed',
                    'status' => 'cancelled',
                ]);

                Log::info('Order payment failed', ['order_id' => $orderId]);
            }
        }
    }
}