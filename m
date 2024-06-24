Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BB71A2FA4
	for <linux-sgx@vger.kernel.org>; Mon, 24 Jun 2024 23:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271765; cv=none; b=hjpriFc6vScjGt37evPDk5Iw+TKvSihWTz31cINC/p4PZKmGpZ8iChZAJzifoT90jDfEpZgpKx5yyvhjoDFpYHoMz0LdHx5gUBGUBT+y4zrpBCXEgVVEy9BK09XPm8XuwruUrJjHcVw0nO6AR8VWc0xqjW259UCY11Zhpah0Hmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271765; c=relaxed/simple;
	bh=J8ziRZLZ6OEx+woE/eS0qKgArMtBUzmObf9KlKhPFtM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QGggXUeewq8wWdeKNZHblTfhg0hDGyfCxnz0lKKHz6qCTOLX42ap4/ijKQil0JiTRj0PuewDvsKVTF8di8aOlJnkh6bU+FubwjAyMbGgTmraMos1sWtBVZO+Ts5c8V/I9sop6Bo4y7c/hCkRWLeN7c/aInhJ8SFF8n5UhacRqCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JsmpU7pO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JsmpU7pO"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7065df788f6so4801342b3a.3
        for <linux-sgx@vger.kernel.org>; Mon, 24 Jun 2024 16:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719271763; x=1719876563; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fldosNIASu5foth+y++2astaddaovQjRCjbJvozT8Ew=;
        b=JsmpU7pOJgpB/KfAdoRKL4BbFDqPuXOVMZBwyLMRyfDB3ZXsc9vBQ8eONaGJ1PVSry
         OCJwDri/iU1QRSFh691va+oP61gM42lTsVyn/wbzlO86MjID74C1OZBta7UwnVuvjf6e
         cannbyUjoe74qL1F09QpxaeN71twaQN0hBlId5iEVxqPzPCb4nID+XKydr9Ym7niRFnY
         mUJ9KHgO8+CHFAIZN0gnCUNNIMq5dapBdXbl+RVnlcQwgfaNLnU4uyPWRFNjVbdCK7xM
         dzW4FeiSY5/srawBlx3/SDtuj6l8qTtN0nCdCZkJk76k1xUjtN3kiIdSD+bXCA5tB6y1
         fLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719271763; x=1719876563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fldosNIASu5foth+y++2astaddaovQjRCjbJvozT8Ew=;
        b=pkkHFHAEcjbsuhsKmtr4sutHuvLPAXPK67X+PdhRH9oIdgJK2vJKKfhRux480+TSfB
         ho3yvCaRJA8wiCWEVOBoUGDASYaVJd9RvFQty6bYOL+TJjJjq+9CBqYQNrCuqMhm78pl
         tUhS7UwyKRQ4qOxkUCcC0nizc8iwe2dPT8leKcjAp7I8AWRbslQratJ+J7Psxw1qycVG
         uFAf8EtOVbd2DKMs8b4OCEWHjWzdGqznSS4NZGZTA04AVZYnntPjz+6h0d2a4EhIooyC
         /kxaUoq0v0VmSevKapANNXd1d1mViLld/2XxniwhMw676DfER9CcGxzCenJOsyzSZiQG
         F0Vg==
X-Forwarded-Encrypted: i=1; AJvYcCVH51plGCokyySzSLBiNUi/Mm/B6egyDdZyohPlASp9O18b365EQlNBSxPhFBTjtqPWq38QbDKTBceT/K+ASsyvgs/bQNILTIBp
X-Gm-Message-State: AOJu0Yxva6+MGSWMmeVYtwIYC+yH91z3ztSgm53G3PMwIhfMubIfVKUF
	m4cebbic3pTXRkXJJDSXWfTfbKJhhA+GKVBOS7wPTCy8X78FoEUayBmt8jznzdbXw3By1hOBHfM
	JrA==
X-Google-Smtp-Source: AGHT+IHgIjs0ZNjmgMymaYfJ8/9bZ93vYmLowFGFa4rCwsJRE0/Jc/du7SfPX0zd6RD0YkkBKKfvO6Hly8E=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6a00:908c:b0:706:3421:7406 with SMTP id
 d2e1a72fcca58-7067454bf95mr299109b3a.1.1719271763360; Mon, 24 Jun 2024
 16:29:23 -0700 (PDT)
Date: Mon, 24 Jun 2024 23:26:14 +0000
In-Reply-To: <20240624232718.1154427-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624232718.1154427-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240624232718.1154427-6-edliaw@google.com>
Subject: [PATCH v6 05/13] selftests/futex: Drop redundant -D_GNU_SOURCE CFLAGS
 in Makefile
From: Edward Liaw <edliaw@google.com>
To: linux-kselftest@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, 
	Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	"=?UTF-8?q?Andr=C3=A9=20Almeida?=" <andrealmeid@igalia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, usama.anjum@collabora.com, seanjc@google.com, 
	kernel-team@android.com, Edward Liaw <edliaw@google.com>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

-D_GNU_SOURCE= will be provided by lib.mk CFLAGS, so -D_GNU_SOURCE
should be dropped to prevent redefinition warnings.

Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/futex/functional/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 994fa3468f17..f79f9bac7918 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 INCLUDES := -I../include -I../../ $(KHDR_INCLUDES)
-CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE= -pthread $(INCLUDES) $(KHDR_INCLUDES)
+CFLAGS := $(CFLAGS) -g -O2 -Wall -pthread $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt
 
 LOCAL_HDRS := \
-- 
2.45.2.741.gdbec12cfda-goog

