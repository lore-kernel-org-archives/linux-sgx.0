Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA86C221299;
	Mon, 23 Jun 2025 21:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713449; cv=none; b=Y8owHoj/7Q8WAWPAsx8xrGCm1SLlkJAOT4hQOichhuL7hYc1FZMDpgHxA5160NXeYhS37IR3xk3lJAoCCaiKXhmqXg+ZaeARr4yPheg41yC/7ZcHIa6Azd2U6DB+ZnBsErcNchEMCCW9lvIGBQy0crbw2z6rbWU5h1Nobfve76g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713449; c=relaxed/simple;
	bh=txSxS7S1Tk8O5KyF8jOuzm6f9+VOYzEjmBJoorVz37A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8vmn/SMSWhHzELE8yq1G5YPUhRxOz5prEdPSgv4BSnocmRqux9hMeH8nbYUbqB1nQD+3QHNjPdHiprIWk5sg6nhaiuumcM4qGaHmCZqFAEOG+39t7fZmiG7wjaB1Wgo66Rr/QK9gBcayOv4xVXSpA3H9Kegfb3Rdl070fsSKcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLggA5Rd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLggA5Rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56167C4CEEA;
	Mon, 23 Jun 2025 21:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713448;
	bh=txSxS7S1Tk8O5KyF8jOuzm6f9+VOYzEjmBJoorVz37A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLggA5RdiaAIm04pwAN6eVRFEJ2tZvkgHG1p4oxWsa3b9Yb7MS0nk76GmDfYAOLit
	 KS+smvnroMNXh9JQCB48aav9kGiLTWpQcS8DRh3hHB4Hw85STnnnt1H5OfERYqhG/r
	 xc/vpcrFCicT3ujujB7Ki6CHjk7uA+/89Bz8nnjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Zaborowski <andrew.zaborowski@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tony Luck <tony.luck@intel.com>,
	balrogg@gmail.com,
	linux-sgx@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 348/592] x86/sgx: Prevent attempts to reclaim poisoned pages
Date: Mon, 23 Jun 2025 15:05:06 +0200
Message-ID: <20250623130708.726165552@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Zaborowski <andrew.zaborowski@intel.com>

[ Upstream commit ed16618c380c32c68c06186d0ccbb0d5e0586e59 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8ce352fc72ac3..7c199773705a7 100644
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
-- 
2.39.5



