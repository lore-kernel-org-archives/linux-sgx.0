Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86652C43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 19:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67DC3206BA
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 19:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFTTrS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 15:47:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:26025 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfFTTrS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 15:47:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 12:47:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="160774653"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by fmsmga008.fm.intel.com with ESMTP; 20 Jun 2019 12:47:14 -0700
Date:   Thu, 20 Jun 2019 22:47:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH] x86/sgx: Use mmu_notifier.release() instead of
 per-vma refcounting
Message-ID: <20190620194714.GD15383@linux.intel.com>
References: <20190619182216.5684-1-sean.j.christopherson@intel.com>
 <20190620194519.GC15383@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194519.GC15383@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 20, 2019 at 10:45:19PM +0300, Jarkko Sakkinen wrote:
> On Wed, Jun 19, 2019 at 11:22:16AM -0700, Sean Christopherson wrote:
> > Using per-vma refcounting to track mm_structs associated with an enclave
> > requires hooking .vm_close(), which in turn prevents the mm from merging
> > vmas (precisely to allow refcounting).
> > 
> > Avoid refcounting encl_mm altogether by registering an mmu_notifier at
> > .mmap(), removing the dying encl_mm at mmu_notifier.release() and
> > protecting mm_list during reclaim via a per-enclave SRCU.
> > 
> > Removing refcounting/vm_close() allows merging of enclave vmas, at the
> > cost of delaying removal of encl_mm structs from mm_list, i.e. an mm is
> > disassociated from an enclave when the mm exits or the enclave dies, as
> > opposed to when the last vma (in a given mm) is closed.
> > 
> > The impact of delying encl_mm removal is its memory footprint and
> > whatever overhead is incurred during EPC reclaim (to walk an mm's vmas).
> > Practically speaking, a stale encl_mm will exist for a meaningful amount
> > of time if and only if the enclave is mapped in a long-lived process and
> > then passed off to another long-lived process.  It is expected that the
> > vast majority of use cases will not encounter this condition, e.g. even
> > using a daemon to build enclaves should not result in a stale encl_mm as
> > the builder should never need to mmap() the enclave.
> > 
> > Even if there are scenarios that lead to defunct encl_mms, the cost is
> > likely far outweighed by the benefits of reducing the number of vmas
> > across all enclaves.
> > 
> > Note, using SRCU to protect mm_list is not strictly necessary, i.e. the
> > existing walker with encl_mm refcounting could be massaged to work with
> > mmu_notifier.release(), but the resulting code is subtle and fragile (I
> > never actually got it working).  The primary issue is that an encl_mm
> > can't be moved off the list until its refcount goes to zero, otherwise
> > the custom walker goes off into the weeds.  The refcount requirement
> > then prevents using mm_list to identify if an mmu_notifier.release()
> > has fired, i.e. another mechanism is needed to guard against races
> > between exit_mmap() and sgx_release().
> > 
> > Cc: Dave Hansen <dave.hansen@intel.com>
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> OK, so what this needs is to split two patches. That can be seen from
> your last paragraph (you are implying it with your note). Then this
> can be sanely reviewed.
> 
> And no, this does not fight by any means with the changes that I'm
> doing.

OK, so please ignore what I just said. You're right what I asked could
not be sanely done :-)

/Jarkko
