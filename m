Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD9046EC70
	for <linux-sgx@vger.kernel.org>; Fri, 11 Sep 2026 22:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789164367; cv=none; b=B/VTkCTmn7ew5A37UGno4RhQvRrtOW6Orxg0H+WChRyka+3BaGKv1aF8XBwNZ903aLe6QXhZloBwoHKe5UQ7yf4nuiN9SURIxlQqoPrp1p7VYHta7OAU9RHwZNDkoK+KsOyYygzIclGpx5J9ehkxoXl1SgRZTKVJRbmwqi031qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789164367; c=relaxed/simple;
	bh=+Nta8YPZVefYEO1aRFgF/H7PuUinfGQhnelVspNKxQA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SXh7UPhszK4DBgmxdrt+EobIN7RdpItV8SZzicB2jqvSh0bSBgEvZCsVkghGzs9ai04tUgkF2dBmabH3YmRjcWyZRAq9/lexOw23WZBjUPkSmmPqczpTKeFBn/ExXoZzEwE4JmyShtrCg+JxLRkU2CvKd8fZGAAuXEpkUj9mzg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sp/mD6Jw; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sp/mD6Jw"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e785dso188895e9.2
        for <linux-sgx@vger.kernel.org>; Fri, 11 Sep 2026 15:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789164364; x=1789769164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U3zc1ebSvTigefNAfZt7P8fRxfSxR3IvYrqoRzdTcdY=;
        b=Sp/mD6JwPZCB2a7/84sfoz6gnJk9EbTrKtHJd00pz70QK1hTJL5HDwR6SJFmGfRSqf
         buVW3/RLEk3TqDQw9x5hV8+lFR56zV7AiW0irSVuHVT+HlWzVgCFyomdcXWc6+/JDK1D
         YuHlDq6wMNdkpxdaMdA8ef0UX/4GbxIDJXO//XSrbFtOP45a8IEx11XUy2kacusHz2DW
         QnOE0Ti5lYCp81Dcnvyz9QY0hLU+8Apn7spYno9lksg+b1QN4iFTuN8vfqO2MK6/0VBr
         5URXc1t5pH/ONPLHKi++aPSbIgLAZfcoDfm93iwb3V9Ign8Okm3rxgzX/sEh18MGRPV/
         pl5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789164364; x=1789769164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U3zc1ebSvTigefNAfZt7P8fRxfSxR3IvYrqoRzdTcdY=;
        b=Vm+R/DqMSTSI+cY+Z1v1fWa/jTkFOmz2yurLSMEb6ho2cNLB9a1wPPueR4ggQnrk53
         QHXFGTxx0rJh30u1+4K2P3lN8aBTxdfFOMGCbKuI8ERDAzO23+U/utkJr0m6L1RBTh9M
         ZJp5+eaKIrlFNjGLjQpQeWE4zcE/OwUWgQbdZHiZ+a8fCPesdeuMlN6n/7XW8ECINL9A
         sn3v47gtg2qEJ0E1crMOp82zAk/myy5kLYiNU8VZNUW+BSLA0xmnboIqXtxCt8bRJrWL
         dmReFYJac90Sjpa04x3qjeEZ3gphtzgtKh6nq/nq7XvlNWahugHF+WMLTq1iA6yjyDln
         niPg==
X-Forwarded-Encrypted: i=1; AKwUvBxV51caXkd7g2RCcyg1V40aokKPUAGqeDh1NIwJmloKYs/SSbAENxKLZMAJyCr9THQGY1ak50siY3M=@vger.kernel.org
X-Gm-Message-State: AFuF++k3gjsLrMqGfbIyxkHe6Lr4SgA8hcmJV3m3ZC9IMK7sP/LLU7gr
	d51NK5fVxtVm1zTwZpd5UgPoA280K6W3Umi/ak888xiv7U2gHoJDFHfsWf5r4dTe
X-Gm-Gg: AYBFou1pEF+OnZmIMzi6KGa505RDetFpymHd53iUMQAmtWepJz6GKVS5StNNPywPaH7
	qIF40WRaM9DPEw/2n7CsBKjK0iu3aMHX2VIt+4gb58WymfiQOB1nXDd3q0O7SYfw0ubCpHP+hbl
	8KW9UVYlVLGiY/ALsN+KFfIa9Z3uw01huSJV16xRlmMMud6yv1KwTk9NUJ4xUuVRMWZzsgbcXlZ
	P0wErk6TCagqw88CCss22CAgST2ISW1v5lK11VYBUrHaYBc5t9MeboIEqqJHu71dB1bULkyocF3
	BQyrWC/VOoq+4hgqpvi2jdYcjSFOt0+CC51XMbwOYleWEJB7ywamf9EIysAy0AGJZqZyjnM0I54
	TJ4rWtnhbHJseLemMA+6tTux9Jd9BLF6gLl3RRYw8IDj6HnAfM3lzT/RbttZM78pNLB/d08L/ou
	EH3TNrhAqdL/L/krs0vmfEHNYH0RoDF83vmA7AWSjJDgRJkA2b3S8WSWZlIOWvIcbmXjfUA5TfF
	jnvumkdYku4NWS1fy3iDsq45YmYml62f+ool4ymqaJsODhSeeIeCdCQ3Qdq1Wmoa0DcjwLhDiq4
	kRu2mUAzd+VRnaCtxome3g8fT8JVYtsE/J1TVvWXFMv4GVI=
X-Received: by 2002:a05:600c:6219:b0:49d:39:90ba with SMTP id 5b1f17b1804b1-49e6caacf0dmr1036035e9.3.1789164363937;
        Fri, 11 Sep 2026 15:06:03 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-114-033-154.95.114.pool.telefonica.de. [95.114.33.154])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60adaee4sm153244765e9.14.2026.09.11.15.06.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Sep 2026 15:06:02 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kai Huang <kai.huang@intel.com>,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Fix the return value in __sgx_alloc_epc_page() kernel-doc
Date: Sat, 12 Sep 2026 00:04:42 +0200
Message-Id: <20260911220442.6815-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__sgx_alloc_epc_page() returns ERR_PTR(-ENOMEM) when no EPC page is
available, but its kernel-doc says that this case returns NULL. Document
the error pointer returned when the node search is exhausted.

Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4505f808af5e5f248d89f47006fcd38de3968cf3..f6b24f362e4155a5bf4d27a84622a1cf03c6320c 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -475,7 +475,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
  *
  * Return:
  * - an EPC page:	A borrowed EPC pages were available.
- * - NULL:		Out of EPC pages.
+ * - ERR_PTR(-ENOMEM):	Out of EPC pages.
  */
 struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
