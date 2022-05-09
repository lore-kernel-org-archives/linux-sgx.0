Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA256C433FE
	for <linux-sgx@archiver.kernel.org>; Mon,  9 May 2022 21:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiEIVxk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 17:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiEIVwc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 17:52:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDA227B334
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 14:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652132895; x=1683668895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pVPMh9qJI0zCKvPUmbl5njR/x7X71fdJBQf7+7YHM/c=;
  b=Tis+p0Ziw8FZiHnBDNT0JLgv91Zc2RSaBtt4j8duSXmP4y/Wq/d1TE+Y
   o7U0XkEyN045NBLB7Usx5nd6ZtH1mNIYCDpsADkMmsr7l6sxamkir78I/
   TkZqcQFnnIwTJAOos7kQVb7UpHshlOwRYO4FpQrPWDreP1/Ti2Edq/BJb
   M+fF2dKcRM7GvFnY2TijzoEuE+fmdW3CEB+QPFY6CjEM14uBtcYgZKtn3
   JZT3wJgxuclV5rp321m8gsCYRVagOkyC+KZrq0frCMHqQgITF/sS35hsI
   V6ume2YPqzRH90oTayrQO3nUCKZp1LQumqRZZHTCtfGV5IXE7wSm7fUHR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="332212854"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="332212854"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:48:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="565293496"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:48:08 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Subject: [PATCH V2 3/5] x86/sgx: Obtain backing storage page with enclave mutex held
Date:   Mon,  9 May 2022 14:48:01 -0700
Message-Id: <b98b7b0d60778845eceb4e279b4354632b7111f2.1652131695.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1652131695.git.reinette.chatre@intel.com>
References: <cover.1652131695.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Haitao reported encountering a WARN triggered by the ENCLS[ELDU]
instruction faulting with a #GP.

The WARN is encountered when the reclaimer evicts a range of
pages from the enclave when the same pages are faulted back
right away.

The SGX backing storage is accessed on two paths: when there
are insufficient free pages in the EPC the reclaimer works
to move enclave pages to the backing storage and as enclaves
access pages that have been moved to the backing storage
they are retrieved from there as part of page fault handling.

An oversubscribed SGX system will often run the reclaimer and
page fault handler concurrently and needs to ensure that the
backing store is accessed safely between the reclaimer and
the page fault handler. This is not the case because the
reclaimer accesses the backing store without the enclave mutex
while the page fault handler accesses the backing store with
the enclave mutex.

Two scenarios are considered to describe the consequences of
the unsafe access:
(a) Scenario: Fault a page right after it was reclaimed.
    Consequence: The page is faulted by loading outdated data
    into the enclave using ENCLS[ELDU] that faults when it checks
    the MAC and PCMD data.
(b) Scenario: Fault a page while reclaiming another page that
    share a PCMD page.
    Consequence: A race between the reclaimer and page fault
    handler, the reclaimer attempting to access a PCMD at the
    same time it is truncated by the page fault handler. This
    could result in lost PCMD data. Data may still be
    lost if the reclaimer wins the race, this is addressed in
    the following patch.

The reclaimer accesses pages from the backing storage without
holding the enclave mutex and runs the risk of concurrently
accessing the backing storage with the page fault handler that
does access the backing storage with the enclave mutex held.

The two scenarios ((a) and (b)) are shown below.

In scenario (a), a page is written to the backing store
by the reclaimer and then immediately faulted back, before
the reclaimer is able to set the dirty bit of the page:

sgx_reclaim_pages() {                    sgx_vma_fault() {
...                                      ...
  sgx_reclaimer_write() {
    mutex_lock(&encl->lock);
    /* Write data to backing store */
    mutex_unlock(&encl->lock);
  }
                                         mutex_lock(&encl->lock);
                                         __sgx_encl_eldu() {
                                           ...
                                           /* Enclave backing store
                                            * page not released
                                            * nor marked dirty -
                                            * contents may not be
                                            * up to date.
                                            */
                                           sgx_encl_get_backing();
                                           ...
                                           /*
                                            * Enclave data restored
                                            * from backing store
                                            * and PCMD pages that
                                            * are not up to date.
                                            * ENCLS[ELDU] faults
                                            * because of MAC or PCMD
                                            * checking failure.
                                            */
                                           sgx_encl_put_backing();
                                         }
                                         ...
/* set page dirty */
sgx_encl_put_backing();
...
                                         mutex_unlock(&encl->lock);
}                                        }

In scenario (b) below a PCMD page is truncated from the backing
store after all its pages have been loaded in to the enclave
at the same time the PCMD page is loaded from the backing store
when one of its pages are reclaimed:

sgx_reclaim_pages() {              sgx_vma_fault() {
                                     ...
                                     mutex_lock(&encl->lock);
                                     ...
                                     __sgx_encl_eldu() {
                                       ...
                                       if (pcmd_page_empty) {
/*
 * EPC page being reclaimed              /*
 * shares a PCMD page with an             * PCMD page truncated
 * enclave page that is being             * while requested from
 * faulted in.                            * reclaimer.
 */                                       */
sgx_encl_get_backing()  <---------->      sgx_encl_truncate_backing_page()
                                        }
                                       mutex_unlock(&encl->lock);
}                                    }

In scenario (b) there is a race between the reclaimer and the page fault
handler when the reclaimer attempts to get access to the same PCMD page
that is being truncated. This could result in the reclaimer writing to
the PCMD page that is then truncated, causing the PCMD data to be lost,
or in a new PCMD page being allocated. The lost PCMD data may still occur
after protecting the backing store access with the mutex - this is fixed
in the next patch. By ensuring the backing store is accessed with the mutex
held the enclave page state can be made accurate with the
SGX_ENCL_PAGE_BEING_RECLAIMED flag accurately reflecting that a page
is in the process of being reclaimed.

Consistently protect the reclaimer's backing store access with the
enclave's mutex to ensure that it can safely run concurrently with the
page fault handler.

Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Reported-by: Haitao Huang <haitao.huang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index fad3d6c4756e..a60f8b2780fb 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -310,6 +310,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	sgx_encl_ewb(epc_page, backing);
 	encl_page->epc_page = NULL;
 	encl->secs_child_cnt--;
+	sgx_encl_put_backing(backing);
 
 	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
 		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
@@ -381,11 +382,14 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
+
+		mutex_lock(&encl_page->encl->lock);
 		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&encl_page->encl->lock);
 			goto skip;
+		}
 
-		mutex_lock(&encl_page->encl->lock);
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
@@ -413,7 +417,6 @@ static void sgx_reclaim_pages(void)
 
 		encl_page = epc_page->owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
-		sgx_encl_put_backing(&backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
-- 
2.25.1

