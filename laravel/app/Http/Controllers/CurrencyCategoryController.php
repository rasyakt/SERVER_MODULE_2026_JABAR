<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Currency;
use App\Models\Category;

class CurrencyCategoryController extends Controller
{
    public function currencies()
    {
        $currencies = Currency::all();

        return response()->json([
            'message' => 'Get all currencies successful',
            'data' => [
                'currencies' => $currencies
            ]
        ], 200);
    }

    public function categories()
    {
        $categories = Category::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Get all categories successful',
            'data' => [
                'categories' => $categories
            ]
        ], 200);
    }
}
