Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F544158A03
	for <linux-sgx@vger.kernel.org>; Wed, 22 May 2024 01:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716339740; cv=none; b=fiiyPrbXF1wzY8OM/BkQw0SqpErJC8XswGnEdY2Rb+pL6y2lbsbPbE4n8ezAC++jBnabBFfRBuoX7e8QPtprYdgOF/k/GSYVEhxkvoB6VQZG0sAK+GqWTx4UkS9PRWUs6gJXYvTG872JKqH54HEkFnH832wo8FmRMwXwBVQT+Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716339740; c=relaxed/simple;
	bh=6sKEuw4EVR0IjH9p2JPj0dqFuh+QrksESybdQuYCbp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n+ItXkqJSyRj8IVAKlAz6RGQwRHcEzkdC0zx4FszLz5EzZOAhfBtqiGFXcx8PjrInrJZBgSzt0b/rKMe6lFwi7US/LCGqe9uo505P0U5iD3hsOT4rOcIWmsI8mW34WAfdM5MZt8RizMemUEMipF26HaPnVwbukcBanEvLRmLiBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CKKlEEYW; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CKKlEEYW"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61be1fcf9abso195242497b3.1
        for <linux-sgx@vger.kernel.org>; Tue, 21 May 2024 18:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716339737; x=1716944537; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2p/91SZXiolultWfykg7Se/3Y6CJnO46NmIdpmtDTd8=;
        b=CKKlEEYWF+NfTDnKd8/N6EsXuD83wZZn0uhGBJvjGnaoPdsTet98ronmi/8o6oWGCc
         8lHK/RThrOjmrkpYd/HX6cXv0q1M/hfAyY9+7MVIX9ppTgCtIxrTOx5yD0DmDQTmJ+4T
         IQNlxjAiwW7mFP9izBD5avmaaRwRr5a7yvmiZ/HRQj/qnzaJX1wAyGsCrMCymvWpREVO
         r4t+8BLfd0veriBNFHmmAZgQHTTH0VqB5BfUN4llgyt9qvOL9to37hDilnc4OL5swrkZ
         31BaTtcMVMwdaaW2pruyIfCfPiio6SAc9xKVF3HRLs3Mq+0yNgN/8urIWxZnVWoZM6OQ
         fY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716339737; x=1716944537;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2p/91SZXiolultWfykg7Se/3Y6CJnO46NmIdpmtDTd8=;
        b=CpE6YsKkXU57SneMrYtR/NCm2shrSZVRUJjTWhJqHQJ2MwwZLsJgdc6e3XctJ/yH0B
         wKbTdxU8jR8b9r5QOjkg5om5deysS4sBK5kYR98sPthcEmBE+jNMplZ6kmokUnQMUNdY
         +kxfTOsX8srBhmTFb7qLmUU2PAjaO2gPVvaxFYzO4vq8esHTr2JGFCOgBdgW0buHvcqP
         O+YSGoia5VfJlLxcP5+eyPXdcPWRWDBLSUjXB5yWk/wBwXUkUwXe2mx1W01PxQsfoi+5
         eLANSj12Kc1tZ7dmXX5bOwvbsWtWJHD0fIYxIZC8tikoAOIWlOhV5EMwelkE0lqjBMp9
         qzlw==
X-Forwarded-Encrypted: i=1; AJvYcCU1rBS6PKWa74g1dDBq4Kct/vHTcC4QcL1bEuw+//l/fuVdvzGd5ujkPAmsCA2iR6HNEOgxqgsGqXxdq4Og5rUod/3/r+nbYrJu
X-Gm-Message-State: AOJu0Yx7IZjicZyyIFgVpWub6+Md0x/r7PYzlAdQKXgBTjPg1LU+nfFP
	Q0BPegqKCr0Odx9mGLKp2kAGnZdl5nE8ypxADQrUStj4NSropjmwqFY+BfM3w/0vhYlbaj7tjbB
	UCw==
X-Google-Smtp-Source: AGHT+IGfhOk9YJsYNy8CZV+lV+R/zOJsJYrZoh4Vhc9wR+bdPu7ruFNEsPOKmbOVrGY3YMxlYG3w5xawAtE=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a0d:d80d:0:b0:627:dad9:bf54 with SMTP id
 00721157ae682-627e48c3490mr1899317b3.10.1716339737591; Tue, 21 May 2024
 18:02:17 -0700 (PDT)
Date: Wed, 22 May 2024 00:57:43 +0000
In-Reply-To: <20240522005913.3540131-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522005913.3540131-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240522005913.3540131-58-edliaw@google.com>
Subject: [PATCH v5 57/68] selftests/sgx: Compile with -D_GNU_SOURCE
From: Edward Liaw <edliaw@google.com>
To: shuah@kernel.org, "=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, Christian Brauner <brauner@kernel.org>, 
	Richard Cochran <richardcochran@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Edward Liaw <edliaw@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@android.com, linux-security-module@vger.kernel.org, 
	netdev@vger.kernel.org, linux-riscv@lists.infradead.org, bpf@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add -D_GNU_SOURCE to HOST_CFLAGS and remove #define _GNU_SOURCE.

Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202404301040.3bea5782-oliver.sang@intel.com
Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/sgx/Makefile    | 2 +-
 tools/testing/selftests/sgx/sigstruct.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

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
index d73b29becf5b..200034a0fee5 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
-#define _GNU_SOURCE
 #include <assert.h>
 #include <getopt.h>
 #include <stdbool.h>
-- 
2.45.1.288.g0e0cd299f1-goog

