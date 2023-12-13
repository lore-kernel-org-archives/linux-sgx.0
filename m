Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWMUWNy+"
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61270B7
	for <linux-sgx@vger.kernel.org>; Wed, 13 Dec 2023 01:04:05 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-677fba00a49so52280386d6.1
        for <linux-sgx@vger.kernel.org>; Wed, 13 Dec 2023 01:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702458244; x=1703063044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RdVPfNmCoTl0yzTJCJRwQ+50ddM61/qqqil23sCnHdg=;
        b=iWMUWNy+LKwaYFy+egqq/eVhGk+ItmFK+/+II8+XmTMLuAqWur1HKqi3TX1tAgRTjM
         V2P4XjspWA81PqJmEsSckmrE6hfP4p/1pP3XCDcOfJXQrqsep/Voyq9D6XDQX/ufx/FL
         cLXDabwCXHepZo1lguhv1PcR1OpbmLr0oA1qbl9zywegqevu6A7cmxqEtVfmZwyVbf1M
         oKuK+zHCU/Vd6xsepZQrUrZ+DQKZ9r3NBuLbk8mPSBollmWEyi91kSvQuQXX/Jlh2spn
         NYsiDja1mpeW6bx9syJKIlBA2bW8JilZvPBSBN2p/UrYwFdHy2n9lPaKBfMgx9WH1eeO
         sByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702458244; x=1703063044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RdVPfNmCoTl0yzTJCJRwQ+50ddM61/qqqil23sCnHdg=;
        b=r5+14PZ9Jpl6xHFvZhraeCHhHtXsbuiydufp+iVk6JAPjXZJDyRLWtSXQdfeaQd8ri
         20lm2h759rogh29WLLJqBwINFzzTXEXZ/1+tClu6IHbAHm4Lml7f7BjE/qdMesRFp6jT
         TatXSTxS0cwqIF1jCbsmSyscyiPIQvSIwETF+re1F+nPRALgVfNI7IMyDfN8Z5H3GJdf
         SsTyhk7eUzzJhJmrvvsQODF94mlWdUOPLt7xivlhBKRUWIoNVsKho+x2qK1O2PsRv6CO
         GpxFW6Pdl4Qti+xJzcuSAd6ex5RXXGHvsFbU5Z1/SryLK893lmrksITD+xT1zjDIEhXF
         wFAg==
X-Gm-Message-State: AOJu0YyS01mUzEvDc+VYETLaTxBcXPMFKhTbG7NkZGqB6p2ECyvwFVSO
	FbuqtnFTrJVdfteHg4+Kl4E=
X-Google-Smtp-Source: AGHT+IGodh5BmnYKBDHHF/9el0cA0spWrzQGkPA2s+rs693Z6LQqnoQ3e8idjNq3O0GVRyqndTeJ2A==
X-Received: by 2002:a05:6214:20c8:b0:67e:fda1:7d5a with SMTP id 8-20020a05621420c800b0067efda17d5amr508110qve.2.1702458244325;
        Wed, 13 Dec 2023 01:04:04 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id mi8-20020a056214558800b0067835abc38bsm4906053qvb.129.2023.12.13.01.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 01:04:03 -0800 (PST)
From: Kevin Hao <haokexin@gmail.com>
To: x86@kernel.org,
	linux-sgx@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] x86/sgx: Remove unnecessary try_to_freeze()
Date: Wed, 13 Dec 2023 17:03:43 +0800
Message-Id: <20231213090343.1070577-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A freezable kernel thread can enter frozen state during freezing by
either calling try_to_freeze() or using wait_event_freezable() and its
variants. However, there is no need to use both methods simultaneously.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
---
 arch/x86/kernel/cpu/sgx/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 166692f2d501..318165b3ff78 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -404,9 +404,6 @@ static int ksgxd(void *p)
 	WARN_ON(__sgx_sanitize_pages(&sgx_dirty_page_list));
 
 	while (!kthread_should_stop()) {
-		if (try_to_freeze())
-			continue;
-
 		wait_event_freezable(ksgxd_waitq,
 				     kthread_should_stop() ||
 				     sgx_should_reclaim(SGX_NR_HIGH_PAGES));
-- 
2.39.2

