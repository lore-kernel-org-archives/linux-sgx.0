Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E1AC433ED
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68BA361165
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhDHJXL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 05:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhDHJXK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 05:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A14861157;
        Thu,  8 Apr 2021 09:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617873779;
        bh=Qsy3D6UysNC/1EHoMjEdpyt0BxDVDJUfNA9Kf1wt2Mo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YkNGz3NVsPKy/uK9wz6jXPydow7yrThKjpYqnYWNUs0qgU23TXUjL5B/bqsWNcmGE
         af0xJknyhZt/Js7XimzrQKmFrhcux+IL4Oqhcq4XaK7H2O4i46qiSfXEhcDFJ1b92Q
         S9RoA/rhswjk8l3inUv42XaStjk8x40xg1Y1OMBNWnyTpRiRJKozAVgsfy3j4D4Qp/
         1/4GEXD4hHXaxxRzxDyjxOV5u5spC3YEf9NyhInZSIp9Lc5AWxD6CQeSsi6DgrNBOz
         +fGIntxlopeAXPmyy1c8hHt6eAhu1DcV3MpyJ/UcCHlVO2J/OAGx+OAo3unDK8tlTr
         tWwvgmMONKeeg==
Date:   Thu, 8 Apr 2021 12:22:56 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/sgx: Do not update sgx_nr_free_pages in
 sgx_setup_epc_section()
Message-ID: <YG7LcLFKokoGzslp@kernel.org>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210407154934.GF25319@zn.tnic>
 <YG3X454GI4U2BZVU@kernel.org>
 <20210407161811.GK25319@zn.tnic>
 <YG7DbunDoPocsEzZ@kernel.org>
 <20210408085640.GD10192@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408085640.GD10192@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 08, 2021 at 10:56:40AM +0200, Borislav Petkov wrote:
> On Thu, Apr 08, 2021 at 11:48:46AM +0300, Jarkko Sakkinen wrote:
> > The regression is that the sgx_nr_free_pages is also incremented by
> > sgx_free_epc_pages(), and thus it ends up having double the number of
> > pages available.
> 
> So when you add a new EPC section with sgx_setup_epc_section(), those
> new pages in "nr_pages" are initially not going to be accounted
> anywhere? Or is that sgx_nr_all_pages? And you do that in your second
> patch...
> 
> But those new pages coming in *are* free pages so they should be in the
> free pages count too, IMHO.

They are not in the "free_page_list" before sanitization process has put
them to there. So in that way the count is also better in sync with this
fix.

It was even before NUMA patches kind of out-of-sync, i.e. free pages count
was incremented before putting them to the free list, but it didn't matter
that much because sanitization is fairly fast and it only prevented ksgxd
to trigger small time after the booth.

I think I'll send the fix for this now as a separate patch with a better
descriptino so that I can use more time to the attributes and implement
that properly at once.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
