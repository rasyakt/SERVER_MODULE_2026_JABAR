<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Wallet extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'user_id',
        'name',
        'currency_code',
    ];

    protected $appends = [
        'balance',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function currency()
    {
        return $this->belongsTo(Currency::class, 'currency_code', 'code');
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'wallet_id');
    }

    public function getBalanceAttribute()
    {
        // Sum up transaction amounts: income adds, expense subtracts.
        // If wallet is deleted or there are no transactions, it defaults to 0.
        $transactions = $this->transactions()->with('category')->get();
        $balance = 0;
        foreach ($transactions as $transaction) {
            if ($transaction->category) {
                if ($transaction->category->type === 'INCOME') {
                    $balance += $transaction->amount;
                } elseif ($transaction->category->type === 'EXPENSE') {
                    $balance -= $transaction->amount;
                }
            }
        }
        return $balance;
    }
}
