Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3450D21C190
	for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 23:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521127; cv=none; b=O2/eW6CmOeleiWlKOGgb30rYCznlTIBGnqM8KPHXFSO5fkyVknAIrBRAkrV9W9LTUZeo9GwauNkjnHCJ8sRU51G/1E2ES6u5yVCLUyvCDCknpXFfuwaPVnvs/aInUn56mtcGpk60P0YKwR4vAmLWl6Oye3ixycQxb/f8//ubcKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521127; c=relaxed/simple;
	bh=Cwp4S5VNvQqFtoPw/nroKEGF2YpUUdO6wVGQiqGsbAY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YB3i0rSHAvy4MjzaiWe5QR1X6+rJ8hLZ+ZPeFYuJqxITTbemXBH31qhNc+0VqYwOXbO4WlzneU4rDjc7rzGJ3IjNwVrUhGEKiZ3p/j2Ky+5SPxzy+Kf9zPKYjcFeP70Qk+pXyQtc6dTprgHu0YnPEaoqCUcPIvNZg1WZADFPZcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=folleoKM; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="folleoKM"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de604d35ec0so3951318276.3
        for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 16:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714521124; x=1715125924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eMZD6S1LecT7yIEbG0UvTaidEBINYi20NzKFmLDZVV4=;
        b=folleoKMFVRvi8dW0bCiqpuMPxaVBXHSqPGhHmRQaNl6zqayRuzzzaiG2Tb3zA83iP
         morx19xZkRe6kEGkwp1Zt+otnWqi/wra9Jb0bO1/Cm/jVdJepjsIOnu97ooL44chizIz
         H/v35//62TlWRSkl0h+OKxiamUjvRTtlnlfn8QDJNf8qbRLbdsmF+tZPhYYzgXZZ/RSo
         YEKSrhK5D5pa9B/One0ZHUJcy8B1+rkGOQPtDSHsZwe9h8sMxuMuxxn/eXV1AwN3nQo0
         wbJ4oDqc8rKxRh8+Zo96DUlmHEPSLi+8zvO0fX9aMDpyv+Eyc3XFv7dDyoeSRtKfGd5h
         YqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714521124; x=1715125924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eMZD6S1LecT7yIEbG0UvTaidEBINYi20NzKFmLDZVV4=;
        b=p/WczTUsu8F7rLc13W7HoI2PkW/JwwBuXFLx0L8RBBpiGIE3+3DhZMQ4Y2wyNx5yYU
         X/oaZJau9tksB7dyCbLAi1mmLrIwaDPNBnVLp3CEUgUTOfCNc7000oumW5WEJw9nyI9z
         giaDC7k6P4YqzcrmBz41o2y9fihciVf1AIceZ2va70/YcXTzhJ4ckE1CNTXL9e6mz0l7
         81so0Wb0tb3PYTDPEuap/bOj49bhEBZb/eN59ebj4N9vnyLj5u9zgezCYc12uW+brOfA
         AFD0t3/U2ucvWYtDYbRu6BD3WBqFgzrF3yL1ytz5s0D6bL6pEYEXfu+2FPJGkx6DDZsU
         uU+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVy0nWJZ6M+chmIo0M9Y4wN52Kh3skDlbyWo+sbeyBPapBXkQmidRyd/5ny8Axz9uEGeU2F5QhPGk/wL2O85ZAtK5msIyaiLOVa
X-Gm-Message-State: AOJu0Yw6H9OyNAb9RQ+rqB2hcB74h97Xexa0vk1JAegJKInY8rhEoCBJ
	S99Cf4/K2KP/JWUVJNl72gop9hKiiGJX2kDBVMAcZXorhvQCIzh8l2qQVOz+I78CTdhUNrtkkmh
	PFA==
X-Google-Smtp-Source: AGHT+IH4VJpB6ZdNUNwNGYphVaIrnOi2jx2Xja9WJZJclJ5U3AS0GX9uELFDr7+Yl08gZsB5HUor9KgguaE=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6902:154b:b0:de5:3003:4b7b with SMTP id
 r11-20020a056902154b00b00de530034b7bmr333229ybu.1.1714521124169; Tue, 30 Apr
 2024 16:52:04 -0700 (PDT)
Date: Tue, 30 Apr 2024 23:50:19 +0000
In-Reply-To: <20240430235057.1351993-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430235057.1351993-11-edliaw@google.com>
Subject: [PATCH v1 10/10] selftests/user_events: Compiled with -D_GNU_SOURCE
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
 tools/testing/selftests/user_events/Makefile   | 2 +-
 tools/testing/selftests/user_events/abi_test.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/user_events/Makefile b/tools/testing/selftests/user_events/Makefile
index 10fcd0066203..344a71769113 100644
--- a/tools/testing/selftests/user_events/Makefile
+++ b/tools/testing/selftests/user_events/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
+CFLAGS += -Wl,-no-as-needed -Wall -D_GNU_SOURCE $(KHDR_INCLUDES)
 LDLIBS += -lrt -lpthread -lm

 TEST_GEN_PROGS = ftrace_test dyn_test perf_test abi_test
diff --git a/tools/testing/selftests/user_events/abi_test.c b/tools/testing/selftests/user_events/abi_test.c
index 7288a05136ba..3e3a0327afdc 100644
--- a/tools/testing/selftests/user_events/abi_test.c
+++ b/tools/testing/selftests/user_events/abi_test.c
@@ -5,7 +5,6 @@
  * Copyright (c) 2022 Beau Belgrave <beaub@linux.microsoft.com>
  */

-#define _GNU_SOURCE
 #include <sched.h>

 #include <errno.h>
--
2.45.0.rc0.197.gbae5840b3b-goog

