Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6656D41C63;
	Thu, 15 May 2025 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747329491; cv=none; b=CGfM6JI6rrpd5DaexyEs0j95AYw66UM4XF+bARDZ5+mokMVQ0Xd0D0tvL9GuXxmzXxuOjShEgK1/vfkWmX5orX664/ksItWRCdH7iyIg9m6U5II4TVBfqbqHPfpwSzPgfQ6ZC7ol5Jo2AzXJoXiWkR/s0dfRvYq4vcb2ieYeCEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747329491; c=relaxed/simple;
	bh=a4Qne7EUq3njwu3tN8seiT1B8K9bvCdm/3W2UzwVpPA=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:MIME-Version:
	 Message-ID:Content-Type; b=tn9FGO28n14YPuyunBpXJsWzHO/azLxPEPTuRzOhoAZohEcCdeAW8EGOrccbhXqwsDizyu75+cZnBSLKe/W46PmPlVoinpuKnIvF5mP7zDuD62ysALeOwX/SyO6+4X5nhV/KvQMSpzED0cR3NfAVfhZMQpxZ06E2LdDEgbCp1cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=tXqUVW5E; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ZTufoNb5; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="tXqUVW5E";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ZTufoNb5"
Date: Thu, 15 May 2025 17:18:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1747329487;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pw173M98a5WT126GMnv8GVkdic7b6WV49PZGTOyDE9I=;
	b=tXqUVW5EqPsyP9zq59pdPZJdHXcyR1dIYgKIc9YgQ7YmxDTDiBBfetdGVL840QB/Z/vwMn
	ljIMzXSvz5Y1TLPKZj3dDFMvJNBxbEQMIse4f28u5eJfwW7oSNcWC87z6h1CI8gFgff/jG
	layj/5+CZ8AeONwmgLCqCwUIpOrTtHa7VqWAios/guDjGY8Ge4rEMHuwjhMOcq17q1r9QU
	H7GuWeAHpbSAPM/cW0o6bNWA7DtD0xfTBpA6C8QiOLKzow7qkZ9vT0YkcDYUKETIui2uUn
	c50U9ruou2w0BZXudGnSOPvH3zChwfHTCkfZTsV3UZ3dGaPYySSMW/xkSJJ+jg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1747329487;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pw173M98a5WT126GMnv8GVkdic7b6WV49PZGTOyDE9I=;
	b=ZTufoNb5S1BPHjt3pzlJPu99yOnVj9GiubnFr1iJIHX3pdbzsDhHG8pKAVQlMKNhHYq+ae
	FRJ8pZ4ymQDXolDg==
From: "tip-bot2 for Andrew Zaborowski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip: x86/sgx] x86/sgx: Prevent attempts to reclaim poisoned pages
Cc: Andrew Zaborowski <andrew.zaborowski@intel.com>,
 Ingo Molnar <mingo@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Tony Luck <tony.luck@intel.com>, balrogg@gmail.com, linux-sgx@vger.kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250508230429.456271-1-andrew.zaborowski@intel.com>
References: <20250508230429.456271-1-andrew.zaborowski@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <174732948660.406.520307759495972754.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The following commit has been merged into the x86/sgx branch of tip:

Commit-ID:     ed16618c380c32c68c06186d0ccbb0d5e0586e59
Gitweb:        https://git.kernel.org/tip/ed16618c380c32c68c06186d0ccbb0d5e0586e59
Author:        Andrew Zaborowski <andrew.zaborowski@intel.com>
AuthorDate:    Fri, 09 May 2025 01:04:29 +02:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Thu, 15 May 2025 19:01:45 +02:00

x86/sgx: Prevent attempts to reclaim poisoned pages

TL;DR: SGX page reclaim touches the page to copy its contents to
secondary storage. SGX instructions do not gracefully handle machine
checks. Despite this, the existing SGX code will try to reclaim pages
that it _knows_ are poisoned. Avoid even trying to reclaim poisoned pages.

The longer story:

Pages used by an enclave only get epc_page->poison set in
arch_memory_failure() but they currently stay on sgx_active_page_list until
sgx_encl_release(), with the SGX_EPC_PAGE_RECLAIMER_TRACKED flag untouched.

epc_page->poison is not checked in the reclaimer logic meaning that, if other
conditions are met, an attempt will be made to reclaim an EPC page that was
poisoned.  This is bad because 1. we don't want that page to end up added
to another enclave and 2. it is likely to cause one core to shut down
and the kernel to panic.

Specifically, reclaiming uses microcode operations including "EWB" which
accesses the EPC page contents to encrypt and write them out to non-SGX
memory.  Those operations cannot handle MCEs in their accesses other than
by putting the executing core into a special shutdown state (affecting
both threads with HT.)  The kernel will subsequently panic on the
remaining cores seeing the core didn't enter MCE handler(s) in time.

Call sgx_unmark_page_reclaimable() to remove the affected EPC page from
sgx_active_page_list on memory error to stop it being considered for
reclaiming.

Testing epc_page->poison in sgx_reclaim_pages() would also work but I assume
it's better to add code in the less likely paths.

The affected EPC page is not added to &node->sgx_poison_page_list until
later in sgx_encl_release()->sgx_free_epc_page() when it is EREMOVEd.
Membership on other lists doesn't change to avoid changing any of the
lists' semantics except for sgx_active_page_list.  There's a "TBD" comment
in arch_memory_failure() about pre-emptive actions, the goal here is not
to address everything that it may imply.

This also doesn't completely close the time window when a memory error
notification will be fatal (for a not previously poisoned EPC page) --
the MCE can happen after sgx_reclaim_pages() has selected its candidates
or even *inside* a microcode operation (actually easy to trigger due to
the amount of time spent in them.)

The spinlock in sgx_unmark_page_reclaimable() is safe because
memory_failure() runs in process context and no spinlocks are held,
explicitly noted in a mm/memory-failure.c comment.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: balrogg@gmail.com
Cc: linux-sgx@vger.kernel.org
Link: https://lore.kernel.org/r/20250508230429.456271-1-andrew.zaborowski@intel.com
---
 arch/x86/kernel/cpu/sgx/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8ce352f..7c19977 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -719,6 +719,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 		goto out;
 	}
 
+	sgx_unmark_page_reclaimable(page);
+
 	/*
 	 * TBD: Add additional plumbing to enable pre-emptive
 	 * action for asynchronous poison notification. Until
