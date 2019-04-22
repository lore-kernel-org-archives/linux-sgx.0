Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8C4C10F11
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 22:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E642520685
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 22:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbfDVW0r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 18:26:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:17402 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727336AbfDVW0r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 18:26:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 15:26:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,383,1549958400"; 
   d="scan'208";a="144948466"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga007.fm.intel.com with ESMTP; 22 Apr 2019 15:26:46 -0700
Date:   Mon, 22 Apr 2019 15:26:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave()
 to allow parameter passing on untrusted stack
Message-ID: <20190422222646.GN1236@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <cover.1555965327.git.cedric.xing@intel.com>
 <ba2a51568f3adaf74994d33ea3cbee570e20c6f6.1555965327.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba2a51568f3adaf74994d33ea3cbee570e20c6f6.1555965327.git.cedric.xing@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 01:42:58PM -0700, Cedric Xing wrote:
> The previous __vdso_sgx_enter_enclave() requires enclaves to preserve %rsp,
> which prohibits enclaves from allocating and passing parameters for untrusted
> function calls (aka. o-calls).
> 
> This patch addresses the problem above by introducing a new ABI that
> preserves %rbp instead of %rsp. Then __vdso_sgx_enter_enclave() can anchor
> its frame using %rbp so that enclaves are allowed to allocate space on the
> untrusted stack by decrementing %rsp. Please note that the stack space
> allocated in such way will be part of __vdso_sgx_enter_enclave()'s frame so
> will be freed after __vdso_sgx_enter_enclave() returns. Therefore,
> __vdso_sgx_enter_enclave() has been changed to take a callback function as an
> optional parameter, which if supplied, will be invoked upon enclave exits
> (both AEX (Asynchronous Enclave eXit) and normal exits), with the value of
> %rsp left off by the enclave as a parameter to the callback.

Please resend this series with the new code as a separate function, not a
modification to the existing function.  Andy made it pretty clear that he
prefers a separate vDSO function, and it'll be a lot easier to provide
feedback on the code if we're working from a clean slate.  If you want to
push to get everything lumped into a single function then by all means do
so on LKML, but for the RFC let's keep the focus on the code itself and
simplify life for reviewers.

  On Tue, Mar 26, 2019 at 10:08:31AM -0700, Andy Lutomirski wrote:
  > If the answer to both questions is yes, then it seems like it could be
  > reasonable to support it in the vDSO.  But I still think it should
  > probably be a different vDSO entry point so that the normal case
  > doesn't become more complicated.

> Here's the summary of API/ABI changes in this patch. More details could be
> found in arch/x86/entry/vdso/vsgx_enter_enclave.S.  * 'struct
> sgx_enclave_exception' is renamed to 'struct sgx_enclave_exinfo' because it
> is filled upon both AEX (i.e. exceptions) and normal enclave exits.  *
> __vdso_sgx_enter_enclave() anchors its frame using %rbp (instead of %rsp in
> the previous implementation).  * __vdso_sgx_enter_enclave() takes one more
> parameter - a callback function to be invoked upon enclave exits. This
> callback is optional, and if not supplied, will cause
> __vdso_sgx_enter_enclave() to return upon enclave exits (same behavior as
> previous implementation).  * The callback function is given as a parameter
> the value of %rsp at enclave exit to address data "pushed" by the enclave. A
> positive value returned by the callback will be treated as an ENCLU leaf for
> re-entering the enclave, while a zero or negative value will be passed
> through as the return value of __vdso_sgx_enter_enclave() to its caller. It's
> also safe to leave callback by longjmp() or by throwing a C++ exception.

Again, wrap at 75 chars or earlier.  And incorporate checkpatch into your
git send-email flow if you haven't done so already, e.g. checkpatch should
have warned about lines longer than 75 chars.

> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> ---
