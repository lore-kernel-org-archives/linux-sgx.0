Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4F1C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Mar 2021 19:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86CB664ED2
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Mar 2021 19:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhCRT2z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232884AbhCRT2o (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 18 Mar 2021 15:28:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B72D64DBA;
        Thu, 18 Mar 2021 19:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616095724;
        bh=n1alF7UDpJZCRbcWoL3f8LioB2LNSnev57xiFM+Db4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+6amfpjqeECJGjY6sIRMgsL4Yw8bQe5EECAe+3iskbQaa4k+qQhAwtduzsl0M/Vf
         Is0Mj+50uiaynofFjHMmg3qWt/ExWuIwF5k6iqOkb9W1GxFSqkn2K+VCfGv3SW7SeM
         HsCkcWMLsfI5qvQ2tn9gu3cKYKDXr9XvKS2kUSou/bT9iRK+Z4b8j03j9p7/YUly3O
         0RuypCpYnE3g+RMAEHzesKsCQMrPZIt64ev+COxQjTbwvJXNZyJOoK9GvNsDOkQVFL
         dZDPweiViPXVZUvlXU2sxMaNOIV7YjsBjme2KKQ8Mt2wZD6jRXtaNsmMxOca2CI0wT
         qIGj8sY81INuA==
Date:   Thu, 18 Mar 2021 21:28:17 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/sgx: Replace section->init_laundry_list with
 sgx_dirty_page_list
Message-ID: <YFOp0dl0ybo6vODz@kernel.org>
References: <20210317235332.362001-1-jarkko.sakkinen@intel.com>
 <20210318174032.GI19570@zn.tnic>
 <1269283f-ddad-9049-dcf5-818a6ecbbc53@intel.com>
 <20210318190138.GJ19570@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318190138.GJ19570@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 18, 2021 at 08:01:38PM +0100, Borislav Petkov wrote:
> On Thu, Mar 18, 2021 at 11:34:10AM -0700, Dave Hansen wrote:
> > I usually get that after I reboot.  I have to do this:
> > 
> > 	chmod 755 /dev/sgx_enclave
> > 	mount -o remount,exec /dev
> 
> Yap, that did it:
> 
> 0x0000000000000000 0x0000000000002000 0x03
> 0x0000000000002000 0x0000000000001000 0x05
> 0x0000000000003000 0x0000000000003000 0x03
> SUCCESS
> 
> > BTW, that *IS* going to get tripped over all the time.
> 
> Yap, and I saw it last time and we talked about it and I forgot again.
> Conveniently.
> 
> > The selftest needs a better error message.  I'll send a patch.
> 
> Please do.

Yeah, would make sense. Not longer than two or three weeks ago
I wondered what is wrong with my system, up until I realized that
I forgot to remount :-)

Thanks for taking the patches.

> Thx.

 /Jarkko
