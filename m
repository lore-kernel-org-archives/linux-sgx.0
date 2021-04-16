Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E24C433ED
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Apr 2021 13:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 746F2611AC
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Apr 2021 13:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242413AbhDPNIj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Apr 2021 09:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241437AbhDPNIi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Apr 2021 09:08:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 668CF61153;
        Fri, 16 Apr 2021 13:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618578493;
        bh=mwPfgfnLYMWrlprFdYGbybpPMqrVxtOGOCT8xeJ7Yqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OUqqncH30KCU5S6KmmfB6SPBR4936PZ4Ac5XFAYVCN8zKkApbClolq1+/hfeo9nVk
         m5TT/ZsJmgOwbAcWfd9mi9WGzPMtJ2KEtPGsAbYQZDRFMGgBg/x7bm1re1PygUi5xX
         SypPgacUMYpoXTrhlATQ9KfqkbZeDYZ3yPUsp7fBN1tBE2p5mfTrsX7fiVZCOFtGyx
         cn+fyR35rwA7ILBMvKgfZZuQlTCMfI7EZ1rwUTidZS1+daYWCJnZKRelcX9+DLpQSm
         btQImylcAxRlqn5XPrq6jc3jsNX/82/YZuhXpi9cVsRCUqs4DVdVA1AwXdmktq7eJU
         syFa5OG9YIhog==
Date:   Fri, 16 Apr 2021 16:08:11 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Raoul Strackx <raoul.strackx@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] x86/sgx: eextend ioctl
Message-ID: <YHmMO51+jI8NXwuG@kernel.org>
References: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
 <YHbJfXqyhtUb1AKw@kernel.org>
 <928ded49-3e86-eae0-de87-f570cf477aef@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928ded49-3e86-eae0-de87-f570cf477aef@fortanix.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 14, 2021 at 01:01:02PM +0200, Jethro Beekman wrote:
> On 2021-04-14 12:52, Jarkko Sakkinen wrote:
> > On Mon, Apr 12, 2021 at 10:59:56AM +0200, Raoul Strackx wrote:
> >> Creation of an SGX enclave consists of three steps. First, a new enclave
> >> environment is created by the ECREATE leaf function. Some enclave settings
> >> are specified at this step by passing an SGX Enclave Control Structure
> >> (SECS) that contains the enclave MRENCLAVE, MRSIGNER, etc. This
> >> instruction also starts a cryptographic log of the enclave being built.
> >> (This log should eventually result in the MRENCLAVE.) Second, pages are
> >> added to the enclave. The EADD leaf function copies 4KB data to an empty
> >> EPC page. The cryptographic log records (among other properties) the
> >> location and access rights of the page being added. It _does not_ include
> >> an entry of the page content. When the enclave writer wishes to ensure the
> >> content of (a part of) the enclave page as well, she must use the EEXTEND
> >> leaf function. Extending the enclave cryptographic log can only be done
> >> per 256 bytes. Extending the log with a full 4K page thus requires 16
> >> invocations of the EEXTEND leaf function. It is however up to the enclave
> >> developer to decide if and how enclave memory is added to the 
> >> cryptographic log. EEXTEND functions may be issued only for relevant parts
> >> of an enclave page, may happen only after all pages have been added, and
> >> so on. Finally, the enclave is finalized by the EINIT leaf function. Any
> >> new invocations of the EADD or EEXTEND leaf functions will result in a
> >> fault. With EINIT a number of checks are performed as well. The 
> >> cryptographic hash of the final cryptographic log is compared to the
> >> MRENCLAVE field of the SECS structure passed to the ECREATE leaf function
> >> (see step one). The signature (MRSIGNER) over this MRENCLAVE is verified
> >> as well. When all checks pass, the enclave loading is complete and it
> >> enters the executable state.
> > 
> > Who do you expect to read this paragraph, seriously?
> 
> What do you mean? There was a request for more architectural details in the cover letter.

So you are saying that it is well structured text and not a brain dump?

/Jarkko
