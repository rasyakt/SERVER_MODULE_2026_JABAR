<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Wallet;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class WalletController extends Controller
{
    public function index()
    {
        $wallets = Wallet::where('user_id', Auth::id())->get();

        return response()->json([
            'status' => 'success',
            'message' => 'Get all wallets successful',
            'data' => [
                'wallets' => $wallets
            ]
        ], 200);
    }

    public function show($id)
    {
        $wallet = Wallet::find($id);

        if (!$wallet) {
            return response()->json([
                'status' => 'error',
                'message' => 'Not found'
            ], 404);
        }

        if ($wallet->user_id !== Auth::id()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Forbidden access'
            ], 403);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Get detail wallet successful',
            'data' => $wallet
        ], 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required',
            'currency_code' => 'required|exists:currencies,code',
        ], [
            'currency_code.exists' => 'The selected currency code is invalid.',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Invalid field',
                'errors' => $validator->errors()
            ], 422);
        }

        $wallet = Wallet::create([
            'user_id' => Auth::id(),
            'name' => $request->input('name'),
            'currency_code' => $request->input('currency_code')
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Wallet added successful',
            'data' => [
                'name' => $wallet->name,
                'user_id' => $wallet->user_id,
                'updated_at' => $wallet->updated_at,
                'created_at' => $wallet->created_at,
                'id' => $wallet->id,
                'currency_code' => $wallet->currency_code
            ]
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $wallet = Wallet::find($id);

        if (!$wallet) {
            return response()->json([
                'status' => 'error',
                'message' => 'Not found'
            ], 404);
        }

        if ($wallet->user_id !== Auth::id()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Forbidden access'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Invalid field',
                'errors' => $validator->errors()
            ], 422);
        }

        $wallet->update([
            'name' => $request->input('name')
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Wallet updated successful',
            'data' => [
                'id' => $wallet->id,
                'user_id' => $wallet->user_id,
                'name' => $wallet->name,
                'created_at' => $wallet->created_at,
                'updated_at' => $wallet->updated_at,
                'deleted_at' => $wallet->deleted_at,
                'currency_code' => $wallet->currency_code
            ]
        ], 200);
    }

    public function destroy($id)
    {
        $wallet = Wallet::find($id);

        if (!$wallet) {
            return response()->json([
                'status' => 'error',
                'message' => 'Not found'
            ], 404);
        }

        if ($wallet->user_id !== Auth::id()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Forbidden access'
            ], 403);
        }

        $wallet->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Wallet deleted successful'
        ], 200);
    }
}
