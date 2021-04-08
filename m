Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083CDC433B4
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C60D26113C
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhDHJNh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 05:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhDHJNf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 05:13:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2342A61139;
        Thu,  8 Apr 2021 09:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617873204;
        bh=IA8YeQSQMF656fftKdEwivWEWH0wFHjXTX1AVRohL2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YCyoCmIs/ZN+DG+/SWUZ4ugJ1sM8jUq6BI2dHCJDbPUUcN1mGxlJiNSPEmsvZx7k1
         n8g0FQV9QPuB4tWnlg24zJSNIrszeqrjVKwUTUFc8a21Cy0Q6dsjzLW5MgP1kB5GNg
         //SqRqA6LpQ9XwuAVX5SeqHY4Sy1JSrFZrxtW0WmPthrTtbL7jUgE5CLytp5H2d+3Y
         ZwpKFNtPUb+LyU7GUKd6BPFnp0Zl1un9yiYmFblp1d0Bw9h7nQPCc0wqkyRx6iFiuY
         vZDfhBvX+wvEhmOnR0LPt+udmn8hkUygr6LOB7E0wMcDkW5u+cmwCy8ainA1xaka/6
         eDfvUONGV0FeA==
Date:   Thu, 8 Apr 2021 12:13:21 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the
 debugfs
Message-ID: <YG7JMc6b+HZIZqxM@kernel.org>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210405232653.33680-2-jarkko@kernel.org>
 <20210407155636.GG25319@zn.tnic>
 <YG3ZJyMB+S5LcUso@kernel.org>
 <20210407161533.GJ25319@zn.tnic>
 <YG7EWDXmwC9ai38k@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG7EWDXmwC9ai38k@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 08, 2021 at 11:52:40AM +0300, Jarkko Sakkinen wrote:
> On Wed, Apr 07, 2021 at 06:15:33PM +0200, Borislav Petkov wrote:
> > On Wed, Apr 07, 2021 at 07:09:11PM +0300, Jarkko Sakkinen wrote:
> > > I left out "epc" because they are already prefixed with "sgx_".
> > 
> > Are there any other "page" types which are going to be figurating in
> > some pseudofs or is "sgx" == "epc" in this case?
> > 
> > > debugfs was my first shot, but for sure these could be sysfs.
> > 
> > Ok, let's keep it in debugfs for now, it can always be made an ABI later
> > and moved to sysfs. But pls document what those are and what they do and
> > that when in debugfs, there are no guarantees that these interfaces will
> > be there in the future.
> 
> I think these attributes are quite useful information to have available so
> I'd go actually doing sysfs attributes and create
> Documentation/ABI/stable/sysfs-driver-sgx to document them.
> 
> Given that they would go then to the sysfs directory of the driver, then
> probably the legit names for the attributes ought to be:
> 
> - nr_all_epc_pages
> - nr_free_epc_pages
> 
> What do you think?

Actually I think read-only sysctl attributes would be a better idea.

The rationale for this is that we have two misc devices sgx_enclave and
sgx_provision, and these are global attributes even applicable to KVM.

It does not matter functionality-wise, but API-wise it'd look stupid to
directly associate to sgx_enclave.

I.e. I'd add something along the lines of 

static struct ctl_path x86_sysctl_path[] = {
        { .procname = "kernel", },
	{ .procname = "x86", },
	{ }
};

static struct ctl_table x86_sysctl_table[] = {
	{
		.procname       = "sgx_nr_all_pages",
		.mode           = 0444,
                /* rest ... */
	},
	{
		.procname       = "sgx_nr_free_pages",
		.mode           = 0444,
                /* rest ... */
	},
	{ }
};

And write Documentation/x86/proc.rst.

/Jarkko
