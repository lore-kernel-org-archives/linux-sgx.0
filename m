Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF02C433ED
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Apr 2021 16:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 641B061381
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Apr 2021 16:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhDDQE0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Apr 2021 12:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhDDQE0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Apr 2021 12:04:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD4566136A;
        Sun,  4 Apr 2021 16:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617552261;
        bh=sEaItNntg9/E1pYVhYET1DAxvEy36SMyXpldPmdXlak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kz6EoBcQwIMtC6ODI2PQujs3LKKx+BluYOuLVAPa3lazHbRrrJYqCeo0TWkaNkPjV
         nS3r4QLXsfkln8zsQ/OlK06mZLqyNVMiqZ8W9GZJxIqBvEra+nylwPfrykJsUB8Hoo
         t8AZf7wWGbLIAmkcG1wgS3jE4tAtLDbUMkRWlRsF0pqQ9wh6swyGPnDkEVCN6yysxT
         lGY4EcMIH2KBeQT4dhYQeFqMe4hzswaEWDSi6+pW2iS9kYq1b5z5Oh2HlEogswewCS
         o3ezocXKZlXDgshT6VME3SPX0iAjQlA0bVbX7Qdl6YKeWTA21qSIXM8w/yqmCTxAAw
         8OYCnrMSq+P6w==
Date:   Sun, 4 Apr 2021 19:04:18 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Raoul Strackx <raoul.strackx@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] x86/sgx: eextend ioctl
Message-ID: <YGnjgkAQjiS8QcS7@kernel.org>
References: <9688abee-6ba7-e1d9-701e-a5cabac36269@fortanix.com>
 <c7b19652-3b5a-e864-1e0e-3e3d26944398@intel.com>
 <ece49a38-c84d-dba7-6039-b409511e7303@fortanix.com>
 <0498080e-6fdc-ed6d-8efa-d9c3265fe7e5@intel.com>
 <9d15aae0-078a-ed72-6c14-155cd1bf27c5@fortanix.com>
 <247ffbee-0ef6-1b6f-75aa-2dc06df42d5d@intel.com>
 <f94e05f7-e6d0-9253-d74c-09cd200702af@fortanix.com>
 <4a122198-054f-609e-e96c-b69ff941c8a7@intel.com>
 <9a841584-65e8-31e9-6bd4-0140b33434e8@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a841584-65e8-31e9-6bd4-0140b33434e8@fortanix.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 02, 2021 at 08:31:19PM +0200, Jethro Beekman wrote:
> On 2021-04-02 17:53, Dave Hansen wrote:
> > On 4/2/21 1:38 AM, Jethro Beekman wrote:
> >>> So, we're talking here about pages that have been EEADDED, but for
> >>> which we do not want to include the entire contents of the page?
> >>> Do these contents always include the beginning of the page, or can
> >>> the holes be anywhere?
> >> Holes can be anywhere, and EEXTEND calls need not be sequential in
> >> memory address or even relate to the most recently EADDed page.
> > 
> > I think you're referring to the SGX architecture itself here.  The
> > architecture permits this, right?
> 
> Yes.
> 
> > But, why would an enclave loader application ever do this? 
> 
> e.g. to save space
> 
> > Is this something we want to support in Linux?
> 
> Why not? Is there a good reason to not fully support this part of the CPU architecture?

Yes, in generic sense :-)

If one would disagree, that would be same as saying that everything should
execute in ring-0 because that only gives "full support".

/Jarkko
