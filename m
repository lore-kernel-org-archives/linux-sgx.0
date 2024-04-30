Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E01F1C2303
	for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 23:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521081; cv=none; b=EchW09G5ry4Ep8upXn/4JiM+Kefp4jUlBz1sAct9fbTwfxNQRuiT3hUkxOZQmXN39bbozFnfCcIPbgwKc+BdrTdG8avq1vFx/UoQ7HWVj6Jc3H84lWH02ecLEB1TM0myYFhW0+/bQybpPgP709M4OSeZWBPGjWb84YBhAhmpPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521081; c=relaxed/simple;
	bh=hoKCCWVOkE0ESMxaMi+qTIS8AurEZYZfNn5Rvt++a10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IUrHV+uMx4XDJWwFSLpa/Xe7cUH+f/bj7BlBVSrDCGjwEe/w+pJWJzIVTkECvkP1UXlxiWJFcK1r08xIoetv5mDpPMhFBnhzCPUKHMWBsLtJCX8ozhkAtVdQHGmHjSWh5QcJlNUY6jvNJWPdpVEqPrSw6COrOLodqudW3ZlPWaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Yx2vh98; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Yx2vh98"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de59d580f61so9910415276.3
        for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 16:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714521078; x=1715125878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gjaSNnvftOLawQ81uXTzdayleIIMFIclLDs0BuljtK4=;
        b=4Yx2vh985eAUe73b/Mn7onj2pzj/LBoS71ImaFxNWPt/0DIGzmxTlaskzv3d+Gb+Hp
         L2oyQ8B+7Xe0YZPUQst64aeW5xQCZJ9QXvCd83LpZL4+vT/DG5ys9nm6CxNHyB3q2+Mr
         j9r4MsmhFMUh7tLzhQZhsqgCwU0ukuUnqw5JUzUZxw4pwyQPvzdILp98ErP/aW3/auMy
         F/8HNoZtgvnD+ZwgUY7EoXvui5bBGspVCW3oSJhWFO/pKtL7j3F5MTOtOALW1shc33DW
         Yen84kX/hc1OH9b/W8IWVNIozK+opZC24W78s/cOLHhVbp2x5QLhClbx9YC3xI7RLrCc
         n65g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714521078; x=1715125878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjaSNnvftOLawQ81uXTzdayleIIMFIclLDs0BuljtK4=;
        b=sZigHLnT1StWBmnfVmRukrbgw/m1pw05pA70/ag4uaXaUbHRGZCVSnenU9H2NmOZBC
         8F9MekHBicsfeG6IQmXzwB7xLi9iBZztScQHxMvGlk/DJm9QEtABf4bqU+x9USiTqTFz
         McJ3iNT6r09t3mvGIk6sDgvi7jnF7gKomzErn9RyXK1YLx9MupapghzDaWOjoAerBEez
         QRcq2AoSgaYOGO7bm5iR1Gt+GCm8WXneqiJxHMJ0KgixFX3NmWQtOgyVjeZqx4loIGjz
         0rXRsvTYmsmYILV5bV0sNmihZdmnisxtJZvYUVnyWpvY4pKaR28Ag/Wk1O/hogYVQ7LQ
         bpog==
X-Forwarded-Encrypted: i=1; AJvYcCWtAAAdRDvZ9KPkntwsQNHgLnMjelv719KJK2a+g5k1kIBHkfCREiprq8GuUNUC/wNoTcuwpnRcMQJ4kELOpg+QTeffU2MDuFgy
X-Gm-Message-State: AOJu0Yy4opOm4j4xjHYjnxGPr0l2YdoRQGU4cEui1YK8vCtnOCcDicrX
	u7hTsq3iaELep/wc+9TlDBBjyQDavAWkJRiCyopO134yHwPqLFDwu7VjENYCg0sL1/3d7SVENwo
	DIw==
X-Google-Smtp-Source: AGHT+IGPMJHhRXW4IxX0wuIaJEnkwrFiECPVYI3NjrGHekGnxptI0a1rv8ukdUNpyZcLuFV1IvoMatGim7A=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6902:150a:b0:dc2:398d:a671 with SMTP id
 q10-20020a056902150a00b00dc2398da671mr352958ybu.10.1714521078081; Tue, 30 Apr
 2024 16:51:18 -0700 (PDT)
Date: Tue, 30 Apr 2024 23:50:10 +0000
In-Reply-To: <20240430235057.1351993-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430235057.1351993-2-edliaw@google.com>
Subject: [PATCH v1 01/10] selftests/sgx: Compile with -D_GNU_SOURCE
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
	linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"

809216233555 ("selftests/harness: remove use of LINE_MAX") introduced
asprintf into kselftest_harness.h, which is a GNU extension and needs
_GNU_SOURCE to either be defined prior to including headers or with the
-D_GNU_SOURCE flag passed to the compiler.

Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202404301040.3bea5782-oliver.sang@intel.com
Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/sgx/Makefile    | 2 +-
 tools/testing/selftests/sgx/sigstruct.c | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
index 867f88ce2570..272da790d9ae 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -12,7 +12,7 @@ OBJCOPY := $(CROSS_COMPILE)objcopy
 endif

 INCLUDES := -I$(top_srcdir)/tools/include
-HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC
+HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC -D_GNU_SOURCE
 HOST_LDFLAGS := -z noexecstack -lcrypto
 ENCL_CFLAGS += -Wall -Werror -static-pie -nostdlib -ffreestanding -fPIE \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index d73b29becf5b..a0c2de7c5302 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
-
-#define _GNU_SOURCE
 #include <assert.h>
 #include <getopt.h>
 #include <stdbool.h>
--
2.45.0.rc0.197.gbae5840b3b-goog

