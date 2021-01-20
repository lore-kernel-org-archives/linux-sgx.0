Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA78C433E6
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 00:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B805F2371F
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 00:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392700AbhAUANs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 19:13:48 -0500
Received: from mga03.intel.com ([134.134.136.65]:44438 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404206AbhATXhM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 18:37:12 -0500
IronPort-SDR: 1SwFwhgd3QV7gUoKoX0p9EUYd9eGII1cYSdv3OJgd5plvS2XHLhhlBniMtjhVCAmRfKmkBa3eZ
 zSvvrjGKmDdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="179276171"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="179276171"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:36:31 -0800
IronPort-SDR: ucD97IoPyrNTtfI3/PnwHhmlbYcX0bu6KWUt4DUJuhNovPp6D5kKwLX3Wb5iFKgz/ZI224n0kG
 Eec5g1ZZnjmQ==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="354479488"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:36:27 -0800
Date:   Thu, 21 Jan 2021 12:36:25 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>,
        <kvm@vger.kernel.org>, <x86@kernel.org>, <seanjc@google.com>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH v2 12/26] x86/sgx: Add helper to update
 SGX_LEPUBKEYHASHn MSRs
Message-Id: <20210121123625.c45deeccc690138f2417bd41@intel.com>
In-Reply-To: <8613b3f1-c4f6-3e5d-4406-9476727666a7@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
        <5116fdc732e8e14b3378c44e3b461a43f330ed0c.1610935432.git.kai.huang@intel.com>
        <YAgcIhkmw0lllD3G@kernel.org>
        <8613b3f1-c4f6-3e5d-4406-9476727666a7@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 20 Jan 2021 10:36:09 -0800 Dave Hansen wrote:
> On 1/20/21 4:03 AM, Jarkko Sakkinen wrote:
> >> +void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
> >> +{
> >> +	int i;
> >> +
> >> +	for (i = 0; i < 4; i++)
> >> +		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> >> +}
> > Missing kdoc.
> 
> I dunno... kdoc is nice, but I'm not sure its verbosity is useful here,
> even if this function is called from more than one .c file.
> 
> I'd be happy with a single-line comment, personally.
> 

I actually feel the function name already explains what the function does
clearly, therefore I don't think even comment is needed. To be honest I
don't know how to rephrase here. Perhaps:

/* Update SGX LEPUBKEYHASH MSRs of the platform. */

? 
