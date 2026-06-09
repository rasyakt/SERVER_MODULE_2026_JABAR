<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaction;
use App\Models\Wallet;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class TransactionController extends Controller
{
    public function index(Request $request)
    {
        $query = Transaction::whereHas('wallet', function ($q) {
            $q->where('user_id', Auth::id());
        })
        ->with(['wallet', 'category'])
        ->orderBy('date', 'desc');

        if ($request->filled('month')) {
            $query->whereMonth('date', $request->input('month'));
        }

        if ($request->filled('year')) {
            $query->whereYear('date', $request->input('year'));
        }

        $perPage = $request->input('per_page', 25);
        $transactions = $query->paginate($perPage);

        return response()->json($transactions, 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'wallet_id' => 'required|exists:wallets,id,user_id,' . Auth::id() . ',deleted_at,NULL',
            'category_id' => 'required|exists:categories,id',
            'amount' => 'required|integer|min:1',
            'date' => 'required|date_format:Y-m-d',
            'note' => 'nullable|string',
        ], [
            'wallet_id.exists' => 'The selected wallet is invalid or does not belong to the user.',
            'category_id.exists' => 'The selected category is invalid.',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Invalid field',
                'errors' => $validator->errors()
            ], 422);
        }

        $transaction = Transaction::create([
            'wallet_id' => $request->input('wallet_id'),
            'category_id' => $request->input('category_id'),
            'amount' => $request->input('amount'),
            'note' => $request->input('note'),
            'date' => $request->input('date'),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Transaction added successful',
            'data' => [
                'category_id' => $transaction->category_id,
                'wallet_id' => $transaction->wallet_id,
                'amount' => $transaction->amount,
                'note' => $transaction->note,
                'date' => $transaction->date,
                'updated_at' => $transaction->updated_at,
                'created_at' => $transaction->created_at,
                'id' => $transaction->id
            ]
        ], 201);
    }

    public function destroy($id)
    {
        $transaction = Transaction::find($id);

        if (!$transaction) {
            return response()->json([
                'status' => 'error',
                'message' => 'Not found'
            ], 404);
        }

        // Verify the transaction's wallet belongs to the authenticated user
        $wallet = Wallet::find($transaction->wallet_id);
        if (!$wallet || $wallet->user_id !== Auth::id()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Forbidden access'
            ], 403);
        }

        $transaction->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Transaction deleted successful'
        ], 200);
    }
}
