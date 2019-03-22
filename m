Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DE3C43381
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 11:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 076EB2190A
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 11:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfCVLSF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 07:18:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:12789 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbfCVLSF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 07:18:05 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 04:18:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="284933894"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.199])
  by orsmga004.jf.intel.com with ESMTP; 22 Mar 2019 04:17:56 -0700
Date:   Fri, 22 Mar 2019 13:17:54 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190322111754.GH3122@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319230047.GL25575@linux.intel.com>
 <20190321161827.GT4603@linux.intel.com>
 <20190321173813.GF6519@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321173813.GF6519@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 21, 2019 at 10:38:13AM -0700, Sean Christopherson wrote:
> We'd need to refcount the encl_mm and unregister its callback when its
> refcount goes to zero.  I dislike the idea of refcounting both encl and
> encl_mm, but it does seem to be the most (only?) robust solution.
> 
> The alternative is to not refcount encl_mm, e.g. unregister the callback
> when the encl itself is freed, but then there is no way to detect when
> the last vma is closed, i.e. we have to hold the encl_mm until the entire
> mm_struct dies.

Yeah.

> Aha!  Similar to the old 1:1 encl:mm approach, the release callback would
> simply mark the associated entity "dead", in this case the encl_mm.  We'd
> still refcount encl_mm and handle unregistering and whatnot when the last
> vma is closed, i.e. refcount goes to zero.  Marking the encl_mm as dead
> instead of trying to delete it from the list avoids scenarios where we're
> holding a reference to the encl_mm but it's no longer on the list.
> 
> The synchronize_srcu() during release ensures we don't operate on a dead
> enclave.  And the only time we'd take mm_lock is to insert/delete to/from
> the list, i.e. vma open/close, thus sidestepping lock ordering issues
> between mm_lock and mmap_sem.  Traversing the list in the fault handler
> can be avoided by nullifying vm_private_data or by checking the liveliness
> of the enclave iself.

This sounds like like a good refinement! We can give it shot and it does
not completely turn over the implemention that I did, just makes it much
more streamlined. I can cope with this.

/Jarkko
