Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4930ECE58D
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 03:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A91B820B7C
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 03:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732616AbfJJD2i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 23:28:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:26457 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732611AbfJJD2i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 23:28:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 20:28:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,278,1566889200"; 
   d="scan'208";a="187824109"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.255.38.72])
  by orsmga008.jf.intel.com with ESMTP; 09 Oct 2019 20:28:36 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 0/7] x86/sgx: Improve add pages ioctl
Reply-To: haitao.huang@linux.intel.com
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
Date:   Wed, 09 Oct 2019 22:28:36 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.z9fc9yu4wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20191009044241.3591-1-sean.j.christopherson@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 08 Oct 2019 23:42:34 -0500, Sean Christopherson  
<sean.j.christopherson@intel.com> wrote:

> Enhance the SGX_IOC_ENCLAVE_ADD_PAGE{S} ioctl so that userspace can add
> multiple pages to an enclave in a single syscall.  Also provide a flag
> that allows replicating a single source page to multiple target pages so
> that userspace doesn't need to allocate a giant chunk of memory when
> initializing things like the enlave's .bss, heap, etc...
>
> People that actually develop runtimes, please weigh in.  Jarkko also
> suggested going with a fully flexible ioctl, e.g. essentially creating an
> array of the existing struct so that mrmask and/or secinfo can be unique
> per page.  AFAICT that's overkill and more cumbersome to use as it forces
> userspace to allocate the full array.  My understanding is that the
> majority of enclaves will have contiguous blocks of pages with identical
> mrmask and secinfo, e.g. code segments, ro data, etc..., thus the less
> flexible but easier-in-theory to use approach proposed here.
>
We think using the same mask for all pages (solution in this patch set) is  
reasonable. Although it seems odd that all pages would apply the same  
mask, this allows enough flexibility we can foresee.

Another option acceptable to us (Intel SGX runtime) is to change it to a  
flag and have bit zero define whether the whole page is measured via  
EEXTEND. This is simpler and allows other bits reserved for future usages.  
However, it would fail any SGX runtime that is measuring partial page for  
optimization purposes.
