Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37B933AD9C
	for <linux-sgx@vger.kernel.org>; Mon, 19 Jan 2026 09:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768815526; cv=none; b=SmHl/xbcI6U9hyM7bLhZhF8uUoFnMwH4miDezbKJpdXMjSflUyxgihFCpVhwxwCJr2DQ2SqSPQyUh7vjGWHK2gsEtj018+r1kAL6+bMh1SYqnbBPI6cE2T0y5DLMeCKWkPDAcZT4DhkuR9NEA7F7sHYUTSZ55rhKXIR4zKlxPxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768815526; c=relaxed/simple;
	bh=tbqHe7nWTVVi+1lGzHiT6Rzn7QWsfhMb20Yt2chxOYA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=C+tdI01tGeK5kNFZ9YItbQfM6/tudYcl1g9kIGgU1WcpIZYo9SDf3I+oFULNQPcDDxdFK4cPqC0T48gqIbRfQVK+BQZuf1q7ATZSpheapwmjcKwqNhPhutex+LanW4ryNXfvYCIUcsYeaC3p05N46rQZ09ptC6OmiYrWA/Ys5GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D2JJknua; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D2JJknua"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768815523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3KLks8HumG/ct0j0oeu7oaK/KNIPQYniDI5G70s/ceM=;
	b=D2JJknuaplF3GE4LsyJHJb7oSVc90ILSYol6yX3Yf5zZ5f/8r9cLQzIkI2ekorxO9GAXAb
	kN4HNJnYjanQakUzy3remhTF4wHJ2KzSRoh3kzhQD6uWGScdVf7RPlicnttpgQkhzmoA2P
	TY+fKHCXqef0vCSpnZJ17M5C9c0Aarc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-B5URGik9MUGJZuIopPZ58g-1; Mon, 19 Jan 2026 04:38:41 -0500
X-MC-Unique: B5URGik9MUGJZuIopPZ58g-1
X-Mimecast-MFC-AGG-ID: B5URGik9MUGJZuIopPZ58g_1768815520
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47ee1fe7b24so34124335e9.1
        for <linux-sgx@vger.kernel.org>; Mon, 19 Jan 2026 01:38:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768815520; x=1769420320;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3KLks8HumG/ct0j0oeu7oaK/KNIPQYniDI5G70s/ceM=;
        b=cINKPS+xUUC/Ai0C63gvVCojResyADAkE/5nKNf9BjtsrNyClPZzX2RdQZMjpAkX7Z
         CCpaO+dJv2nzrXGImTMpmLxr+CYNKnodR+EUfi/yhjkZrg8zFA4k/CsTF8HJ5WOGz6gK
         oceJtQ18rSiNRlfYsKvSUZYN2CbU8698oOhn3BEvRzHKnXybMINS9a+V1lESBD2VOMzG
         Z/WwVkE4lC8KKQ3O1558opcof/KWiXUz3eKTCQWsO6oTEAx30DyMOUcy/dj5R7K4vSRf
         H1Fy80q9TytqBZ3t3IIUgCAcwwy2p/J6rdQuE4cOTDpA3M+YciUJzfdfCB5mGMIugHIf
         HU3w==
X-Forwarded-Encrypted: i=1; AJvYcCXrZ7vlpUH0u3SjDv6DZMp944OHLF1FlyJFGeh/nUixllQKzVIeYK+/sIraIbNNoj3qjrTLYdcXh04=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxse7+1TcHTDqtlUy5MoYtaXVofBxuCqu+ZORcejjsWHa5x9Iea
	VxyoTbWWaB3rtauWU/xzV4CzGyryo3AfKG1gH+2TnbQ6zyWpxe+sQEjpld68PmyjadZsdnIlJ5E
	VzhmZ3nGduivq2WZdkbqo4lKvx3EFyIjVrjO4wxpnxOX9qeccPjRxhBom9PM/rQ==
X-Gm-Gg: AY/fxX4ZBMeNZBJ2/QVsMnIk28mCF4qoIN0ZVH6j72OvWo5+bKQXVb0An8s/UDce+rO
	FCzo4JCeAHVdYrKoU88wiUKdcjJjjC/zCabgsvC4Lmmv9mxdWTTOlCuIbojnyAxK/nAQSLDHs1D
	7/DzhhydCfMeZnuS+kJSVYUtsrYeXqepBgz7sK9dqex/eGJbWOV9dqhu5CbCasHU7362OC7/pfE
	e6Wnn8cqNSoF3I4SnlTE7iO12ph7wTJiLyOJnB2mpLo1tlZ3oNryHAofmPcpntFIDn5h/c4qAiW
	3Smyg8XrOmO6XZmHoRm1nzC4VfYU3gPYSWGaYZDg8jMk0CT1Nq9rkO1JXyKQJ94orrTYJop5aEx
	tup38YqAXEFzlCDKITCtPEqCNH0Hqr8C9il+akIU9Ny3JjaE53DtEsEGdSQE=
X-Received: by 2002:a05:600c:4e43:b0:47e:d943:ec08 with SMTP id 5b1f17b1804b1-4801e33dc26mr124166345e9.28.1768815520299;
        Mon, 19 Jan 2026 01:38:40 -0800 (PST)
X-Received: by 2002:a05:600c:4e43:b0:47e:d943:ec08 with SMTP id 5b1f17b1804b1-4801e33dc26mr124166015e9.28.1768815519854;
        Mon, 19 Jan 2026 01:38:39 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:1622:5a48:afdc:799f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996cf33sm22661810f8f.25.2026.01.19.01.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 01:38:39 -0800 (PST)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: "H . Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-sgx@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [PATCH] MAINTAINERS: adjust file entry in INTEL SGX
Date: Mon, 19 Jan 2026 10:38:35 +0100
Message-ID: <20260119093835.114554-1-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j36_Mbd9151fhQn4U-7aQiPVkWtW8wCr4urd6kyl0UY_1768815520
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Commit 693c819fedcd ("x86/entry/vdso: Refactor the vdso build") moves the
vdso sources into common, vdso32, and vdso64 subdirectories, but misses to
adjust the file entry in the INTEL SGX section of the MAINTAINERS file.

Adjust the file entry in accordance with the file movement of the commit
above.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14a06f856b81..68f5fec91f96 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13105,7 +13105,7 @@ S:	Supported
 Q:	https://patchwork.kernel.org/project/intel-sgx/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/sgx
 F:	Documentation/arch/x86/sgx.rst
-F:	arch/x86/entry/vdso/vsgx.S
+F:	arch/x86/entry/vdso/vdso64/vsgx.S
 F:	arch/x86/include/asm/sgx.h
 F:	arch/x86/include/uapi/asm/sgx.h
 F:	arch/x86/kernel/cpu/sgx/*
-- 
2.52.0

