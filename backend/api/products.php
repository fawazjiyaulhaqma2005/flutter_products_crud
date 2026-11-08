<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

require_once __DIR__ . '/../database.php';

try {
    // Membuat tabel otomatis jika belum tersedia
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS products (
            id INT AUTO_INCREMENT PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            description TEXT,
            price DECIMAL(12,2) NOT NULL DEFAULT 0,
            category VARCHAR(100),
            thumbnail TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ");

    $method = $_SERVER['REQUEST_METHOD'];
    $id = isset($_GET['id']) ? (int) $_GET['id'] : 0;

    $input = json_decode(file_get_contents("php://input"), true);

    // READ: Menampilkan semua produk atau detail produk
    if ($method === 'GET') {
        if ($id > 0) {
            $stmt = $pdo->prepare("SELECT * FROM products WHERE id = ?");
            $stmt->execute([$id]);
            $product = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$product) {
                http_response_code(404);
                echo json_encode(["success" => false, "message" => "Produk tidak ditemukan"]);
                exit;
            }

            echo json_encode(["success" => true, "data" => $product]);
        } else {
            $stmt = $pdo->query("SELECT * FROM products ORDER BY id DESC");
            echo json_encode(["success" => true, "data" => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
        }
    }

    // CREATE: Menambahkan produk
    elseif ($method === 'POST') {
        if (!is_array($input) || empty(trim($input['title'] ?? ''))) {
            http_response_code(400);
            echo json_encode(["success" => false, "message" => "Nama produk wajib diisi"]);
            exit;
        }

        $stmt = $pdo->prepare("
            INSERT INTO products (title, description, price, category, thumbnail)
            VALUES (?, ?, ?, ?, ?)
        ");

        $stmt->execute([
            trim($input['title']),
            $input['description'] ?? '',
            $input['price'] ?? 0,
            $input['category'] ?? '',
            $input['thumbnail'] ?? ''
        ]);

        http_response_code(201);
        echo json_encode([
            "success" => true,
            "message" => "Produk berhasil ditambahkan",
            "data" => ["id" => (int)$pdo->lastInsertId()] + $input
        ]);
    }

    // UPDATE: Mengubah produk
    elseif ($method === 'PUT') {
        if ($id <= 0 || !is_array($input) || empty(trim($input['title'] ?? ''))) {
            http_response_code(400);
            echo json_encode(["success" => false, "message" => "ID dan nama produk wajib diisi"]);
            exit;
        }

        $stmt = $pdo->prepare("
            UPDATE products
            SET title = ?, description = ?, price = ?, category = ?, thumbnail = ?
            WHERE id = ?
        ");

        $stmt->execute([
            trim($input['title']),
            $input['description'] ?? '',
            $input['price'] ?? 0,
            $input['category'] ?? '',
            $input['thumbnail'] ?? '',
            $id
        ]);

        if ($stmt->rowCount() === 0) {
            $check = $pdo->prepare("SELECT id FROM products WHERE id = ?");
            $check->execute([$id]);

            if (!$check->fetch()) {
                http_response_code(404);
                echo json_encode(["success" => false, "message" => "Produk tidak ditemukan"]);
                exit;
            }
        }

        echo json_encode(["success" => true, "message" => "Produk berhasil diperbarui"]);
    }

    // DELETE: Menghapus produk
    elseif ($method === 'DELETE') {
        if ($id <= 0) {
            http_response_code(400);
            echo json_encode(["success" => false, "message" => "ID produk wajib diisi"]);
            exit;
        }

        $stmt = $pdo->prepare("DELETE FROM products WHERE id = ?");
        $stmt->execute([$id]);

        if ($stmt->rowCount() === 0) {
            http_response_code(404);
            echo json_encode(["success" => false, "message" => "Produk tidak ditemukan"]);
            exit;
        }

        echo json_encode(["success" => true, "message" => "Produk berhasil dihapus"]);
    }

    else {
        http_response_code(405);
        echo json_encode(["success" => false, "message" => "Method tidak diizinkan"]);
    }

} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Terjadi kesalahan pada server"
    ]);
}
