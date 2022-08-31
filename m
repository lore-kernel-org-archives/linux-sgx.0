Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A989CECAAD1
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Aug 2022 18:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiHaSq5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Aug 2022 14:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbiHaSqp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Aug 2022 14:46:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B74146217;
        Wed, 31 Aug 2022 11:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EA1BB8226E;
        Wed, 31 Aug 2022 18:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4137DC433C1;
        Wed, 31 Aug 2022 18:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661971598;
        bh=XmS1NgimPQdmBNm5/DBsQT42PoX6m38LeV/44DhDS1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SNY5E7qqJ8rzSsJKlQbdcAxEilZ8C6k6eG7iLDkSNo1KdB4PAfp4Q59n2oX5xY2Cb
         vk8REeyDawOFYbD943bp9ZPCjalGJ0m7OsAE5rZVpqlgrjVZ9sOtJSZdyZYWQ6NFYh
         pXKqWdn7/CPn2luA9hFqfwM+9tgBTOJCmC8fPsLAFiQ3xJNTh0sFdoaK3vrxGLpxy9
         jdWb4q5XNFIQoHDB7V5XK5M0lBEb0aLVKhDqWAPA201KHq+JfzA7vGw8YerBSZpNnh
         qG3/Muuo9EzQ0mUGdIOPN+g42qJ2xE5+D3cGq0KjbilfrNqNVWEFJ7hZy1iWWyT8ju
         HE/A7nl7g165Q==
Date:   Wed, 31 Aug 2022 21:46:34 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] x86/sgx: Handle VA page allocation failure for
 EAUG on PF.
Message-ID: <Yw+sioB+RdynmlUm@kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-4-jarkko@kernel.org>
 <20991fdc-1ae4-ef68-c6d4-12372b4e6f73@intel.com>
 <Yw+mtfFs3dvOWOv2@kernel.org>
 <4c24e461-5ac7-7d79-9764-52f8fdfc311e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c24e461-5ac7-7d79-9764-52f8fdfc311e@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 31, 2022 at 11:33:26AM -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 8/31/2022 11:21 AM, Jarkko Sakkinen wrote:
> > 
> > Can you point out what exactly is the whitespace issue?
> 
> There is an extra space after the "=" in:
>        vmret =  VM_FAULT_NOPAGE;

Duh, I did look at it about million times but honestly
did not see it before you pointed it out.

BR, Jarkko
