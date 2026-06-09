<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CurrencyCategoryController;
use App\Http\Controllers\WalletController;
use App\Http\Controllers\TransactionController;
use App\Http\Controllers\ReportController;

// Public authentication routes
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

// Protected routes requiring Sanctum token
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);

    Route::get('/currencies', [CurrencyCategoryController::class, 'currencies']);
    Route::get('/categories', [CurrencyCategoryController::class, 'categories']);

    Route::get('/wallets', [WalletController::class, 'index']);
    Route::get('/wallets/{id}', [WalletController::class, 'show']);
    Route::post('/wallets', [WalletController::class, 'store']);
    Route::put('/wallets/{id}', [WalletController::class, 'update']);
    Route::delete('/wallets/{id}', [WalletController::class, 'destroy']);

    Route::get('/transactions', [TransactionController::class, 'index']);
    Route::post('/transactions', [TransactionController::class, 'store']);
    Route::delete('/transactions/{id}', [TransactionController::class, 'destroy']);

    Route::get('/reports/summary-by-category/expense', [ReportController::class, 'expenseSummary']);
    Route::get('/reports/summary-by-category/income', [ReportController::class, 'incomeSummary']);
});
