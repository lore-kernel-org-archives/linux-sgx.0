Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B93CC742A5
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B4E6208E4
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbfGLD2y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 23:28:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:16390 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728955AbfGLD2y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 23:28:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 20:28:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="168203819"
Received: from gonegri-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.192])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2019 20:28:50 -0700
Date:   Fri, 12 Jul 2019 06:28:49 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org, luto@kernel.org, jethro@fortanix.com,
        greg@enjellic.com, sean.j.christopherson@intel.com
Subject: Re: [RFC PATCH v3 0/3] x86/sgx: Amend vDSO API to allow enclave/host
 parameter passing on untrusted stack
Message-ID: <20190712032849.kp4o7acvla7sc4kl@linux.intel.com>
References: <20190424062623.4345-1-cedric.xing@intel.com>
 <cover.1562813643.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1562813643.git.cedric.xing@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 10, 2019 at 09:21:30PM -0700, Cedric Xing wrote:
> This patchset is based upon, and can be applied cleanly on SGX1 patch v20
> (https://lkml.org/lkml/2019/4/17/344) by Jarkko Sakkinen.
> 
> The current proposed __vdso_sgx_enter_enclave() requires enclaves to preserve
> %rsp, which prohibits enclaves from allocating space on the untrusted stack.
> However, there are existing enclaves (e.g. those built with current Intel SGX
> SDK libraries) relying on the untrusted stack for passing parameters to
> untrusted functions (aka. o-calls), which requires allocating space on the
> untrusted stack by enclaves. After all, passing data via untrusted stack is
> very easy to implement (by enclaves), with essentially no overhead, therefore
> is very suitable for exchanging data in small amounts, so could be desirable by
> future SGX applications as well.  
> 
> This patchset introduces a new ABI for __vdso_sgx_enter_enclave() to anchor its
> stack frame on %rbp (instead of %rsp), so as to allow enclaves to "push" onto
> the untrusted stack by decrementing the untrusted %rsp. And in order to service
> o-calls and to preserve the untrusted stack upon exceptions, the new vDSO API
> takes one more optional parameter - "callback", which if supplied, will be
> invoked on all enclave exits (including normal and asynchronous exits). Ample
> details regarding the new ABI have been documented as comments inside the
> source code located in arch/x86/entry/vsgx_enter_enclave.S
> 
> Please note that there was a lengthy discussion on what is the "best" approach
> for passing parameters for trusted/untrusted calls. Unfortunately there's no
> single "best" approach that fits all use cases, hence this new ABI has been
> designed intentionally to accommodate varieties. Therefore, to those not
> interested in using the untrusted stack, whatever worked with the old ABI
> proposed by Sean will continue to work with this new ABI.
> 
> The SGX selftest has been augmented by two new tests. One exercises the new
> callback interface, and serves as a simple example to showcase how to use it;
> while the other validates the hand-crafted CFI directives in
> __vdso_sgx_enter_enclave() by single-stepping through it and unwinding call
> stack at every instruction. Please note that the selftest CANNOT run to
> completion yet, as it depends on the vDSO fixup code to signal the process upon
> #DB/#BP inside enclaves (rather than the current behavior of branching to the
> handler in vDSO).
> 
> Changelog:
>   · This is version 3 of this patch series with the following changes.
>     - Per Andy Lutomirski and Sean Christopherson, revised comments and their
>       format in arch/x86/entry/vsgx_enter_enclave.S
>     - Per Jarkko Sakkinen, revised the cover letter to articulate motivation
>       and objective of this patchset.
>   · v2 - https://patchwork.kernel.org/cover/10914161/
>   · v1 - https://patchwork.kernel.org/cover/10911615/

1. I agree with the high level idea.
2. The patches do changes out of scope.

Generally, when doing kernel patches, even for a running patch set,
please do not do anything extra.

It is also stated in the kernel process;

https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#separate-your-changes

Once these are fully cleaned up we can merge them.

/Jarkko
