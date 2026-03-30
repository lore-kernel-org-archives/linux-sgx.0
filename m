Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E1D39D6C5
	for <linux-sgx@vger.kernel.org>; Mon, 30 Mar 2026 21:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905015; cv=none; b=lSkyPFaef3gxghcobWzqq8cpBpr/ern4N58zlnj84d1h1ZGhRL726JYe6yMHgY/Pa6rSbG/TC2hNrs0IbZK15/7H5+eOlrMS52aH6+gr1UDDkrs7E0e7Wlrvj6C6jr6NpY58k1+sRzZeVxc8SqLZdDbvlvGE8gvRonkewDX6CPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905015; c=relaxed/simple;
	bh=QWAIbpgsCGqgoeRq9mKxjk8QRS9utd0ORURW77Cr4f8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=meiH7ThWHantFNy0bLQpMtbSdQJAf9BZ7rQJFYHBDwkV6ngl67nP2DiQsEOxBVy12jk6VSB3X/FBunLaWQqJI3CC3I7+jkjnF8C64a0Bz2xShtVBd3+pS1bw7X+5J52wIjMat8wlYM99+4r5pfo/D/xtUYVNFPtTr/oWee77DZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bHDg0Okz; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bHDg0Okz"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8c6f21c2d81so459649785a.2
        for <linux-sgx@vger.kernel.org>; Mon, 30 Mar 2026 14:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774905012; x=1775509812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aa+fex/1gzXGVgDeRYj4FaJ5P8y3pcMc4PmRk/wiRnM=;
        b=bHDg0OkzySZSTtAEGvnrVTXY/7kT7gQ5cATbeEoQc/3g88JcLo92PKh4+lQzNMasnG
         8xI6uULrw8nEdS8WHWPidlxNiZjB5ixAZ4AJbKWyU0fS0bsnj2d4nR298w+70lbuDnYb
         HWqUZfgsq/u0cB202ZRzap8ItlMqRhw4Bxt00Ps8KeUVB9tuFpOXd5nxw3vwEk3mU5oV
         +/yVAYc/D8An/MF9pI9nuIDJzFyekuhYIC2pSp172AKhIIYGGc/pxRrY9rRzetg4VnfR
         Hh5F9nlYP1wudsFtzhleYQP1X1tNg3Ok7MpePKCyuTP/zpBrGTzims1QkPmghT4Jpjgm
         1aiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774905012; x=1775509812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aa+fex/1gzXGVgDeRYj4FaJ5P8y3pcMc4PmRk/wiRnM=;
        b=HEz1lQWij/K2AGbypqMPVO9zMphqDdrYrW1slaMBz5HmrTQJV7co8pKeLSctThDmFl
         3eVFQG5LJad5nAcT03MPZTw3Vj9G6BpIf2+Eu9k+Q7TYDWqlbgezy0uZDqkKwIRWiX4Y
         PK5in/LeHCAGO73It8w+/BaL8m+eybu3kkVmuPdX8qO2eLxxC0OqXdMs/9QRMn3wURhv
         gwvPOAl7suCZBQhvxKzOwZEddahmTxqWqsaJNPP56NytINDHYHm9uB53sujha0uubH/O
         ift+9oHaN3wFNMoR4EuTsMMX0zd9EDxl96Rw+Ae14/6bCeCuT9HxiVxLyWTOE16etXH4
         bSnQ==
X-Gm-Message-State: AOJu0Yy/CQqByF6Vj31uvxzNO/h8wyQjhDlnaEWBHpsPP+7jNqSAtYrU
	s3KT8ZYu0PHTPiI0mbH1tM4BoxwxD9U8AfsZhZT+JPcg1dlx78dJNKy8imNS+vDX
X-Gm-Gg: ATEYQzxCXZW17fbm+I8HAwgYnJ6atrcm5buliT5COswBUXN5bo8FYPZ4JXf4I6qg681
	Trnl5XW1NXbc4Mxl/RBYH2ipTlX9grZZwKm6tHa9E8BzthHA1/yLVGa+Fzw0lo/x4j+JwDtRkbJ
	hHfrPEyfWE30hBIpOLjAdM+YMaX6yIiRovtJFpNNIrX4FqHwk2tU6JmNBJhKsqBIYZrBw2VXQfM
	CPL/qMkYPk7pUt+Wi9z2JyEZWUEgi3NM+nhspA4im7FOiQMAWkbxEbwPjL5Uzs7RHhnt0h5jvwf
	eVL5F1dPz9t1EDMS3rZ0lE6jESg0X+7XpTDhl/3zGQGfqhl+qrsBDxqj1j1DHL8LBT5kFpDOwTr
	pge0Kzh38G7asUnP1HukEzWEGIU6x2xH7cYUBGKFHg1Nm1vOPOBi80JaM0irAD/0xAyQHnXZQOo
	tZN0DqHiFMQVs9AnbQefpzvdnREDg/hRb8i6zxpy3L
X-Received: by 2002:a05:620a:3183:b0:8c6:ff8f:58af with SMTP id af79cd13be357-8d01c7bd490mr1854309685a.51.1774905012416;
        Mon, 30 Mar 2026 14:10:12 -0700 (PDT)
Received: from ArchTX.mobile.psu.edu ([104.39.41.64])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d02e697689sm598715085a.16.2026.03.30.14.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 14:10:11 -0700 (PDT)
From: Dingisoul <dingiso.kernel@gmail.com>
To: linux-sgx@vger.kernel.org
Cc: jarkko@kernel.org,
	dave.hansen@linux.intel.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	shuangpeng.kernel@gmail.com
Subject: [BUG] x86/sgx: missing kref_put() in sgx_encl_mm_add() error path
Date: Mon, 30 Mar 2026 17:09:57 -0400
Message-ID: <20260330210957.839878-1-dingiso.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kernel maintainers,

We found a possible refcount leak in sgx_encl_mm_add().

In this function, a reference to encl->refcount is taken before registering the MMU notifier:

/* Grab a refcount for the encl_mm->encl reference: */
kref_get(&encl->refcount);  // 1. Reference acquired here.
encl_mm->encl = encl;

ret = __mmu_notifier_register(&encl_mm->mmu_notifier, mm);
if (ret) {
	kfree(encl_mm);     
	return ret;         // 2. Returns without kref_put.
}

If __mmu_notifier_register() fails, the function frees encl_mm but does not drop the reference acquired by kref_get(&encl->refcount). This seems to leak one reference to encl.

Please let us know if the kref_put is unnecessary here.

Thanks.
