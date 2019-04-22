Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B08C10F11
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 22:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59B24206A3
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 22:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfDVWGI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 18:06:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:6092 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727588AbfDVWGH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 18:06:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 15:05:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,383,1549958400"; 
   d="scan'208";a="163872983"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga002.fm.intel.com with ESMTP; 22 Apr 2019 15:05:51 -0700
Date:   Mon, 22 Apr 2019 15:05:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/3] An alternative __vdso_sgx_enter_enclave() to
 allow enclave/host parameter passing using untrusted stack
Message-ID: <20190422220551.GM1236@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <cover.1555965327.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1555965327.git.cedric.xing@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 01:42:56PM -0700, Cedric Xing wrote:
> The current proposed __vdso_sgx_enter_enclave() requires enclaves to preserve
> %rsp, which prohibits enclaves from allocating space on the untrusted stack.
> However, there are existing enclaves (e.g. those built with current Intel SGX
> SDK libraries) relying on the untrusted stack for passing parameters to
> untrusted functions (aka. o-calls), which requires allocating space on the
> untrusted stack by enclaves. And given its simplicity and convenience, it
> could be desired by future SGX applications as well.
> 
> This patchset introduces a new ABI for __vdso_sgx_enter_enclave() to anchor
> its stack frame on %rbp (instead of %rsp), so as to allow enclaves to "push"
> onto the untrusted stack by decrementing the untrusted %rsp. Additionally,
> this new __vdso_sgx_enter_enclave() will take one more parameter - a callback
> function, to be invoked upon all enclave exits (both AEX and normal exits).
> The callback function will be given the value of %rsp left off by the
> enclave, so that data "pushed" by the enclave (if any) could be
> addressed/accessed. Please note that the callback function is optional, and
> if not supplied (i.e. null), __vdso_sgx_enter_enclave() will just return
> (i.e. behave the same as the current implementation) after the enclave exits
> (or AEX due to exceptions).
> 
> The SGX selftest is augmented to test out the new callback interface, and to
> serve as a simple example to showcase how to use the callback interface in
> practice.

Please wrap your emails, or use an editor that will do it for you.  75 chars,
plus or minus a few, is generally preferred.

> Cedric Xing (3):
>   selftests/x86: Fixed Makefile for SGX selftest
>   x86/vdso: Modify __vdso_sgx_enter_enclave() to allow parameter passing
>     on untrusted stack
>   selftests/x86: Augment SGX selftest to test new
>     __vdso_sgx_enter_enclave() and its callback interface
> 
>  arch/x86/entry/vdso/vsgx_enter_enclave.S   | 156 ++++++++++++---------
>  arch/x86/include/uapi/asm/sgx.h            |  14 +-
>  tools/testing/selftests/x86/Makefile       |  12 +-
>  tools/testing/selftests/x86/sgx/Makefile   |  45 +++---
>  tools/testing/selftests/x86/sgx/main.c     | 123 +++++++++++++---
>  tools/testing/selftests/x86/sgx/sgx_call.S |  40 +++++-
>  6 files changed, 264 insertions(+), 126 deletions(-)
> 
> -- 
> 2.17.1
> 
