Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F06FC07E9C
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Jul 2021 23:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67F7261CB6
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Jul 2021 23:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhGFXy7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Jul 2021 19:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhGFXy7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Jul 2021 19:54:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91B3F61C1E;
        Tue,  6 Jul 2021 23:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625615540;
        bh=pvy0OPqS/Ta1U4D+VI4UxmGLp8LJAq/PH3Q3HZqVzN8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PiXx+uhwWkplQzsxsJyNpzYNiITUxIR5arH4ptWSUzZjg9V98YnF9yTYEDmPg1hvr
         t9ewtEZ11Axikj4R+2Z4tIr8MoYJMxvX91uGTsn/tnueES3DOpfEMfk+liC983yJM3
         8fRSYIZaRJLEITWamcI8wIQkbsNQiasqpsnwBzQhRuv9LHDNaWuelNeTvZFPiBv0dR
         DTtehpC8i6eNWUKzdrau6cDBgGr5IuElTVYBNkmBFo8hOAw5GDSxsZk/1arL40zXUV
         hRok1UYaF89u90bdJmTVAnSKnhX2f5wU/05ZpVa1NiZItINih42yL6vU7TEvUarPSH
         5Wo6zdz9ltYgw==
Date:   Wed, 7 Jul 2021 02:52:17 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] selftests/sgx: Fix Q1 and Q2 calculation in
 sigstruct.c
Message-ID: <20210706235217.6mre4arpgfsrdxm4@kernel.org>
References: <20210705143652.116125-1-jarkko@kernel.org>
 <20210705143652.116125-3-jarkko@kernel.org>
 <4303b822-5861-ba2c-f620-0e752e499329@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4303b822-5861-ba2c-f620-0e752e499329@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 06, 2021 at 01:53:20PM -0700, Dave Hansen wrote:
> On 7/5/21 7:36 AM, Jarkko Sakkinen wrote:
> > From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> > 
> > Q1 and Q2 are numbers with *maximum* length of 384 bytes. If the calculated
> > length of Q1 and Q2 is less than 384 bytes, things will go wrong.
> > 
> > E.g. if Q2 is 383 bytes, then
> > 
> > 1. The bytes of q2 are copied to sigstruct->q2 in calc_q1q2().
> > 2. The entire sigstruct->q2 is reversed, which results it being
> >    256 * Q2, given that the last byte of sigstruct->q2 is added
> >    to before the bytes given by calc_q1q2().
> > 
> > Either change in key or measurement can trigger the bug. E.g. an unmeasured
> > heap could cause a devastating change in Q1 or Q2.
> > 
> > Reverse exactly the bytes of Q1 and Q2 in calc_q1q2() before returning to
> > the caller.
> > 
> > Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
> > Link: https://lore.kernel.org/linux-sgx/20210301051836.30738-1-tianjia.zhang@linux.alibaba.com/
> > Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> This looks fine, but can I suggest a Subject: tweak?
> 
> 	selftests/sgx: Fix calculations for sub-maximum field sizes

WFM

> 
> In any case:
> 
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>

Thank you.

/Jarkko
