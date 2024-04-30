Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C75201278
	for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 23:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521111; cv=none; b=dF1VxL7ePnN6pJqIE7ZdShx0KPsap9Uyc5FY8G0HhPX7+KjSABylF/iJoOgSS7mHuSX6/aB/Bye9kgDVrY/2HjAIuYuyUug0FD3o3aFlwk4dtSzMK2O2nNvr6htFCkJhv0oRypFL77MBuHnXqPdewNuBhff9QUwbeinbS12NSSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521111; c=relaxed/simple;
	bh=CEhaM1mN6VS3UNUxEOiZzt+NMGfOefhofITadMSxAOk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JLrexidZ+wHgmESNbMVxxKYJr2mrVftelXa74GTkG7s0vUCN278HNK4DkLzHXdPcxKk1qL2CZAOLYxVfxhkWpTrttLRgsopju1paBGgjJ8FyKUuPdAlb4DxkqKMK2c1AVkJUGdoO7w9JlfsmpwTKdCBexCaFD+1Mkuk0k5h7N8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QxTjV1Xy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QxTjV1Xy"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ecfa420e9cso5277041b3a.0
        for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 16:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714521109; x=1715125909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CEhaM1mN6VS3UNUxEOiZzt+NMGfOefhofITadMSxAOk=;
        b=QxTjV1XyjnYQpO1Ojpg+DK3VrvVtrxP8HE2G2RDfKR1jy70vI+Z7E8jy+F4VW1UMAs
         H+/yHC/okin1cr5pf4BNLQoZup5iGVw2Y4n41x7HHxLEXQO3vwCvK6MNAY32KVsBJoZh
         5DCg1jz1OTlgHBIkiHDqj3E2UzRLVO1u0PY/S1z5PxHgfetjXhxm5Hx0Vsc3AIBpBiZ5
         3OUH+/9BR0GhL14neuy5y7mV0rgu5RglbCI6Kr2w/UBlrlCeCyoxPFrwozPud4jd/ePx
         EKJw6DZsZuMeJTzNnkTbQa8LPBOUEo/e7xd81jxuf+ChMeVRMoz/loFnn/YvC1D7ufdL
         +1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714521109; x=1715125909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CEhaM1mN6VS3UNUxEOiZzt+NMGfOefhofITadMSxAOk=;
        b=omVgxIwrzI1rg+F0ZzniQ0eIIHOij2wSgCsf/M+jj/ZoqkyBHpQwDve1+5Thc2iyg/
         91RiqwpvVqsOqgmRcACHiRZ4k8LlKjPjxM7o3y/nSBlww/fAdMw6LoMWfDLoJ3ZZ7OED
         kS4T8vEo7xnyazVpRBpjep0yl4cRfSYhpdPr/555wDFIPb+E7L6mc725pBOFJkgPo9FX
         veA+pjLJ5nZSWbu0xRJR/A80wXtSR0ZVe1iFf0zIkgtWmrw4eio+S13T6oSivqnaF//H
         o4is3//6q8+INTPY0Eolo8TtSsPKTUzEwoJWeedqNjmmRSI55yHf+yrLBbGPlcOYBPDW
         8N3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUR5Lr/sk/I0yyy6bOzX1KGOshL8s/1f1h3+HS9QSSQKM7N51za2w7lc12jwOcmDPgzA3a0BCXyKWy1dlTcw9j7/1RHo3o2sGgF
X-Gm-Message-State: AOJu0YxXV1tWjr9+aIEq9oc/MqflrFEooYhVJLe1k4H57I/mMFTX8ZPD
	QpFzlzydlQlIcdX6Z9dQBKQFGfTtbrrbZ/I48diAOXJDnG5CrOWBdwZxt+T/hkv8c8jTEs0RcFg
	9Mg==
X-Google-Smtp-Source: AGHT+IEcaAknHG3oVxkt/ve4EvpePIZURr0JuhkvcUevAmsAmfJEA0evZy5og+mIh0zfRT7rOUjsW8a0xao=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6a00:2d88:b0:6ea:aafa:815c with SMTP id
 fb8-20020a056a002d8800b006eaaafa815cmr62853pfb.1.1714521109241; Tue, 30 Apr
 2024 16:51:49 -0700 (PDT)
Date: Tue, 30 Apr 2024 23:50:16 +0000
In-Reply-To: <20240430235057.1351993-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430235057.1351993-8-edliaw@google.com>
Subject: [PATCH v1 07/10] selftests/prctl: Compile with -D_GNU_SOURCE
From: Edward Liaw <edliaw@google.com>
To: shuah@kernel.org, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Bongsu Jeon <bongsu.jeon@samsung.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Edward Liaw <edliaw@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@android.com, linux-sound@vger.kernel.org, 
	linux-input@vger.kernel.org, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

809216233555 ("selftests/harness: remove use of LINE_MAX") introduced
asprintf into kselftest_harness.h, which is a GNU extension and needs
_GNU_SOURCE to either be defined prior to including headers or with the
-D_GNU_SOURCE flag passed to the compiler.

Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/prctl/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/prctl/Makefile b/tools/testing/selftests/prctl/Makefile
index 01dc90fbb509..23d319a7a322 100644
--- a/tools/testing/selftests/prctl/Makefile
+++ b/tools/testing/selftests/prctl/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+CFLAGS += -D_GNU_SOURCE
 ifndef CROSS_COMPILE
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
--
2.45.0.rc0.197.gbae5840b3b-goog

