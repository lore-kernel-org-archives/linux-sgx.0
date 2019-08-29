Return-Path: <SRS0=j74F=WZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A16C3A5A6
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 13:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF6E5233FF
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 13:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfH2NPx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 09:15:53 -0400
Received: from mga17.intel.com ([192.55.52.151]:12400 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727644AbfH2NPw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 09:15:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 06:15:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,443,1559545200"; 
   d="scan'208";a="205713462"
Received: from friedlmi-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.54.26])
  by fmsmga004.fm.intel.com with ESMTP; 29 Aug 2019 06:15:44 -0700
Date:   Thu, 29 Aug 2019 16:15:43 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH v2 2/5] x86/sgx: Reject concurrent ioctls on single
 enclave
Message-ID: <20190829131543.ejdsviysr2u33rnj@linux.intel.com>
References: <20190827192717.27312-1-sean.j.christopherson@intel.com>
 <20190827192717.27312-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827192717.27312-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 27, 2019 at 12:27:14PM -0700, Sean Christopherson wrote:
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
> value.  The race could also be fixed by taking encl->lock or making
> allowed_attributes atomic, but both add unnecessary overhead with this
> change applied.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

#PF handler should be good as it has this conditional:

flags = atomic_read(&encl->flags);

if ((flags & SGX_ENCL_DEAD) || !(flags & SGX_ENCL_INITIALIZED))
	return ERR_PTR(-EFAULT);

What about the reclaimer?

/Jarkko
