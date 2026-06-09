<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaction;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    public function expenseSummary(Request $request)
    {
        return $this->getSummaryByCategory($request, 'EXPENSE');
    }

    public function incomeSummary(Request $request)
    {
        return $this->getSummaryByCategory($request, 'INCOME');
    }

    private function getSummaryByCategory(Request $request, $type)
    {
        $query = Transaction::whereHas('wallet', function ($q) {
            $q->where('user_id', Auth::id());
        })
        ->whereHas('category', function ($q) use ($type) {
            $q->where('type', $type);
        });

        if ($request->filled('month')) {
            $query->whereMonth('date', $request->input('month'));
        }

        if ($request->filled('year')) {
            $query->whereYear('date', $request->input('year'));
        }

        $results = $query->select('category_id', DB::raw('SUM(amount) as total_amount'))
            ->groupBy('category_id')
            ->with('category')
            ->get();

        $summary = $results->map(function ($r) {
            return [
                'category' => $r->category,
                'amount' => (int) $r->total_amount
            ];
        });

        $typeName = strtolower($type);

        return response()->json([
            'status' => 'success',
            'message' => "Get summary by {$typeName} category successful",
            'data' => [
                'summary' => $summary
            ]
        ], 200);
    }
}
