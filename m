Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D5D21C163
	for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 23:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521123; cv=none; b=PmZC46jbDpgtOKA9aS7Pm3p7cTHqhlbMrx2FWF6Sk9evFWItBnE2Jy72Cp32t9VFHtRW6pEUIRJIK8v8cfh635CF0XO/MUGxKVDAmg3Oa9W2DMLob6CP+7p+0nU4iup/0hblldy5ab2l0eB7ZitK31qzG5MuOqhZufMs/h9gWbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521123; c=relaxed/simple;
	bh=2QdI2TgmxQKTHiSdbJTZcZLPJCgb3K62uskVNaaDbcM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d5mpbI11UYTR3pC4nwMIJgwwUvA4nURKLbMBcwkwAxVjvYmsmuLITxp15SATJ9D0TLWtExNJJb7KxiSxhGQfV7mS4lJ7SXQ7I7WkpAmwhC2C3IVKNoDGX7bDwfC+mpBd41CbLr81X+BZ4YDVRsiq98/P6XYynxquIVrzEDLVKqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=keeEguSY; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="keeEguSY"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de604ccb373so3710656276.2
        for <linux-sgx@vger.kernel.org>; Tue, 30 Apr 2024 16:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714521119; x=1715125919; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2QdI2TgmxQKTHiSdbJTZcZLPJCgb3K62uskVNaaDbcM=;
        b=keeEguSYKiYQkwXHyB2MrirM7L4y/Sp1KZdZTe1Eb1jtwQtnCsDWIpXRReCNmzLntV
         LaN1vRGXt8Ee/+WveDn79hkXqdatNUKk7+0m0ApxnwA8jk6DQGuWU5HiRiaL6ymJyGyO
         Yt0PhkFkEGuLIC0ibsKHgbJN1rI4ul6Y52GkoerHsIkVg62N96JuJrvtFG+j6kgZdV0O
         81+cIaFsJxjWfMEVeJs2y9JYP7Iwp0gOmXtZCf1DO8OjYA9PRLcQ1pnT3fkcWLCI4g2a
         Us1YG8JSmxTJ2OQb9puJS6qNWWaBllS5bnXGdD7qVSx55UTthCEPpOmyKbbveYBZJqEZ
         f5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714521119; x=1715125919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2QdI2TgmxQKTHiSdbJTZcZLPJCgb3K62uskVNaaDbcM=;
        b=Fw8tyPGo2fN8ihWiB6mRKim6n51VSMxKuINVvcGraeX4aeYK58CNmmjab4p7A9JSR1
         OrjcTumsZSA0WftL6yqlJlrT+bKkKdzrrZwjt6eRlESytvH5UNMUJk5fDKw5ZP5BtMSo
         +rpHUOigxvNp+YKq1Yco43CYRPQnbx+NxV9aJSMpsbBzIbIUpbvKtOhazPIgc0HtA70j
         KnFutmvxjUEP9LZV8kfz/XUp4XbLMcnIhs33hOvOU8Gs4leG3kM92NzaJTWgWafYewIN
         MvbPm4/af9beIbTIRJpwTUGT1KXp5PNnAJvtPq94uDqE4AqOwm8UGQdXAKHX7455bpD7
         hg9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVwqICTp/w3Hf2wORkdW2JqfdvQTg8YqVKofiX6wQAL9+csTQupL8Nwyq+K/jPSm6d1aMw5Mg8b96eeCSIfJhCK36E6ld8iypc3
X-Gm-Message-State: AOJu0YzCo3Qvj12f4Z0UEZNgKNl2D62SvRxUQrVx0gxQ8RqRLhlLU0rP
	zQ+hNpZijsVxirSpBTqlU62gZhuBYn8002ob1jTJDCaLjw2RAbGJoNvTdGrsYsl4NsI7e9xb0ZQ
	Dag==
X-Google-Smtp-Source: AGHT+IGe0w5VioNgUdFLQOVwPulyr7LeCwc9ZxlwAi+xzV7TnsXxdL7cdDTZYaAKG9NQO48kQtKteAJhBhA=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6902:2b83:b0:de5:1e69:642c with SMTP id
 fj3-20020a0569022b8300b00de51e69642cmr175231ybb.5.1714521119181; Tue, 30 Apr
 2024 16:51:59 -0700 (PDT)
Date: Tue, 30 Apr 2024 23:50:18 +0000
In-Reply-To: <20240430235057.1351993-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430235057.1351993-10-edliaw@google.com>
Subject: [PATCH v1 09/10] selftests/tdx: Compile with -D_GNU_SOURCE
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
 tools/testing/selftests/tdx/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tdx/Makefile b/tools/testing/selftests/tdx/Makefile
index 306e9c4d5ef7..5a084a792a21 100644
--- a/tools/testing/selftests/tdx/Makefile
+++ b/tools/testing/selftests/tdx/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0

-CFLAGS += -O3 -Wl,-no-as-needed -Wall $(KHDR_INCLUDES) -static
+CFLAGS += -O3 -Wl,-no-as-needed -Wall -D_GNU_SOURCE $(KHDR_INCLUDES) -static

 TEST_GEN_PROGS := tdx_guest_test

--
2.45.0.rc0.197.gbae5840b3b-goog

