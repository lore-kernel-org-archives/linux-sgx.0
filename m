Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81FCC3A5A3
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 12:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F6C9206BF
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 12:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfH0MLe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Aug 2019 08:11:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:50321 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfH0MLe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Aug 2019 08:11:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 05:11:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="380893339"
Received: from jsakkine-mobl1.fi.intel.com (HELO localhost) ([10.237.66.169])
  by fmsmga006.fm.intel.com with ESMTP; 27 Aug 2019 05:11:26 -0700
Date:   Tue, 27 Aug 2019 15:11:25 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/sgx: Reject concurrent ioctls on single enclave
Message-ID: <20190827121125.rmcsf2qlicb4xduf@linux.intel.com>
References: <20190827001128.25066-1-sean.j.christopherson@intel.com>
 <20190827001128.25066-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827001128.25066-4-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 26, 2019 at 05:11:27PM -0700, Sean Christopherson wrote:
> Except for ENCLAVE_SET_ATTRIBUTE, all SGX ioctls() must be executed
> serially to successfully initialize an enclave, e.g. the kernel already
> strictly requires ECREATE->EADD->EINIT, and concurrent EADDs will result
> in an unstable MRENCLAVE.  Explicitly enforce serialization by returning
> EINVAL if userspace attempts an ioctl while a different ioctl for the
> same enclave is in progress.
> 
> The primary beneficiary of explicit serialization is sgx_encl_grow() as
> it no longer has to deal with dropping and reacquiring encl->lock when
> a new VA page needs to be allocated.  Eliminating the lock juggling in
> sgx_encl_grow() paves the way for fixing a lock ordering bug in
> ENCLAVE_ADD_PAGE without having to also juggle mm->mmap_sem.
> 
> Serializing ioctls also fixes a race between ENCLAVE_CREATE and
> ENCLAVE_SET_ATTRIBUTE, as the latter does not take encl->lock, e.g.
> concurrent updates to allowed_attributes could result in a stale
> value.  The race could also be fixed by taking encl->lock, but that
> is less desirable as doing so would unnecessarily interfere with EPC
>b page reclaim.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I think the error code should be -EBUSY. Our implementation is fairly
coherent at the moment that -EINVAL follows from bad input data. Getting
-EINVAL from this would be a bit confusing.

If atomic_t was used for the enclave flags (see my comment to 1/4), then
I think we could implement this like:

if (atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags) & SGX_ENCL_IOCTL)
	return -EIOCTL;

/Jarkko
