Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F795C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Feb 2021 00:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A26264E53
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Feb 2021 00:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhBJAf5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Feb 2021 19:35:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:58436 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234066AbhBJAVt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Feb 2021 19:21:49 -0500
IronPort-SDR: MFhaoI66IGxCUJ4SIKziyYZNIPwofg2JAv8r+YldaiFWeNzkRmSZCvSgU5fFhm5jBeLhyIL/Df
 VJhaodmPG9kw==
X-IronPort-AV: E=McAfee;i="6000,8403,9890"; a="246051038"
X-IronPort-AV: E=Sophos;i="5.81,166,1610438400"; 
   d="scan'208";a="246051038"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 16:20:41 -0800
IronPort-SDR: pK+v243TtfXWJSiPrR97STHFoUWfBfE13a+T2wjCnycDCnBTG4Rrre9U5SAMxtmRlFGyQ8NxVF
 W5iu+So+inBw==
X-IronPort-AV: E=Sophos;i="5.81,166,1610438400"; 
   d="scan'208";a="510142896"
Received: from aellsw1-mobl.amr.corp.intel.com ([10.251.22.237])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 16:20:36 -0800
Message-ID: <ec9604199072e185de4b6b74209e84f30423c5e3.camel@intel.com>
Subject: Re: [RFC PATCH v4 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Wed, 10 Feb 2021 13:20:32 +1300
In-Reply-To: <9aebc8e6-cff5-b2b4-04af-d3968a3586dc@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
         <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
         <YCL8ErAGKNSnX2Up@kernel.org> <YCL8eNNfuo2k5ghO@kernel.org>
         <9aebc8e6-cff5-b2b4-04af-d3968a3586dc@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-02-09 at 13:36 -0800, Dave Hansen wrote:
> On 2/9/21 1:19 PM, Jarkko Sakkinen wrote:
> > > Without that clearly documented, it would be unwise to merge this.
> > E.g.
> > 
> > - Have ioctl() to turn opened fd as vEPC.
> > - If FLC is disabled, you could only use the fd for creating vEPC.
> > 
> > Quite easy stuff to implement.
> 
> The most important question to me is not how close vEPC is today, but
> how close it will be in the future.  It's basically the age old question
> of: do we make one syscall that does two things or two syscalls?
> 
> Is there a _compelling_ reason to change direction?  How much code would
> we save?

Basically we need to defer 'sgx_encl' related code from open to after mmap(). For
instance, We need to defer 'sgx_encl' allocation from open to SGX_IOC_ENCLAVE_CREATE.
And due to this change, we also need to move some members out of 'sgx_encl', and use
them as common for enclave and vEPC. The 'struct xarray page_array' would be a good
example.

The code we can save, from my first glance, is just misc_register("/dev/sgx_vepc")
related, maybe plus some mmap() related code. The logic to handle both host enclave
and vEPC still needs to be there.

To me the major concern is /dev/sgx_enclave, by its name, implies it is associated
with host enclave. Adding IOCTL to *convert* it to vEPC is just mixing things up, and
is ugly. If we really want to do this, IMHO we need at least change /dev/sgx_enclave
to /dev/sgx_epc, for instance, to imply the fd we opened and mmap()'d just represents
some raw EPC. However this is changing to existing userspace ABI.

Sean,

What's your opinion? Did I miss anything?

