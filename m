Return-Path: <SRS0=uhim=EC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACB3C55178
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 01:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FBA7206E5
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 01:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504160AbgJ0Bwj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Oct 2020 21:52:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:51802 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504096AbgJ0Bwi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Oct 2020 21:52:38 -0400
IronPort-SDR: rNjZPY7aXlEG+ybqppJ4uP6hZ1jupA49ZkwTXhGPsjjJS1qYrsygtj+2DogbNy1rJXLol89HWE
 Uy5NdqKJzNQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="164514575"
X-IronPort-AV: E=Sophos;i="5.77,422,1596524400"; 
   d="scan'208";a="164514575"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 18:52:38 -0700
IronPort-SDR: WdrM7rPOQvoovwU+u7WV+/22loPSyDzXqJN6/dML2KH4k8uF1KXsZboyYCxa/AgDGp4BUGR0vK
 RDCFNvCQj0tw==
X-IronPort-AV: E=Sophos;i="5.77,422,1596524400"; 
   d="scan'208";a="303599154"
Received: from ksprzacz-mobl1.ger.corp.intel.com (HELO linux.intel.com) ([10.252.59.214])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 18:52:26 -0700
Date:   Tue, 27 Oct 2020 03:52:22 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, josh@joshtriplett.org, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20201027015222.GC20485@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200626153400.GE27151@zn.tnic>
 <1ada871a-2350-1007-c625-a00bdb0d439b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ada871a-2350-1007-c625-a00bdb0d439b@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 26, 2020 at 02:26:13PM -0700, Dave Hansen wrote:
> On 6/26/20 8:34 AM, Borislav Petkov wrote:
> >> +	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
> >> +		return -EINVAL;
> >> +
> >> +	if (copy_from_user(&addp, arg, sizeof(addp)))
> >> +		return -EFAULT;
> >> +
> >> +	if (!IS_ALIGNED(addp.offset, PAGE_SIZE) ||
> >> +	    !IS_ALIGNED(addp.src, PAGE_SIZE))
> >> +		return -EINVAL;
> >> +
> >> +	if (!(access_ok(addp.src, PAGE_SIZE)))
> >> +		return -EFAULT;
> >> +
> >> +	if (addp.length & (PAGE_SIZE - 1))
> >> +		return -EINVAL;
> > How many pages are allowed? Unlimited? I'm hoping some limits are
> > checked somewhere...
> 
> What were you concerned about here?  Was it how long the syscall could
> take, or that one user could exhaust all the enclave memory in one call?
> 
> Some later versions of this patch have a 1MB limit per to reduce how
> long each SGX_IOC_ENCLAVE_ADD_PAGES call spends in the kernel.  But, I'm
> not _sure_ that's what you were intending.

The loop does check for pending signals, i.e. it is possible to
interrupt it.

/Jarkko
