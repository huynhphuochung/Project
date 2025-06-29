<?php
require_once('connect_db.php'); // ✅ đúng tên file kết nối

if ($conn) {
    echo "✅ Kết nối thành công!";
} else {
    echo "❌ Không thể kết nối.";
}
?>
