Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F694C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Dec 2021 23:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhL1XeZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 Dec 2021 18:34:25 -0500
Received: from mga17.intel.com ([192.55.52.151]:33020 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231334AbhL1XeY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 28 Dec 2021 18:34:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640734464; x=1672270464;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=T5V45WieA6rPSUJw15geMEXuCIfvmU00SdlOxuBC4rs=;
  b=lKGldSGEtGMJ2LdmXXmCsWo+5MxrF//Ir3mjPz4etvvZ7RIYHUasPTI/
   kwK5sVZKcUgm32TezpW8rBoRfUfpQx+yo+a2RZChA3PNSX+29P9UuxHBZ
   yCxCg9H0rBEbbcQVx7khK5MascfvIl5hQa7AiS3iC2uSDuQSJn7r8cHV9
   OeJKU1oGDXphJxMuvfQ2BnyDlOAwikgWZN6DIaywgdkWmaByfPPHNFcsj
   O9XfV4TbHT1Rsiz7C0MwgMCdVTY0R5jC60s7jc6qgl32kVVR+8AIwLZBt
   8vOBu3R34YmQpIh8sG2K2wf/jfdzXQ5CyEntPUaz5oP5fUr41BTGhY0qy
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="222105638"
X-IronPort-AV: E=Sophos;i="5.88,243,1635231600"; 
   d="scan'208";a="222105638"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 15:34:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,243,1635231600"; 
   d="scan'208";a="470152856"
Received: from jseaman-mobl.amr.corp.intel.com (HELO [10.252.133.172]) ([10.252.133.172])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 15:34:23 -0800
Subject: Re: [PATCH 1/2] x86/sgx: Add accounting for tracking overcommit
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211220174640.7542-1-kristen@linux.intel.com>
 <20211220174640.7542-2-kristen@linux.intel.com> <YcuX/DzVsAWvhEBA@iki.fi>
From:   Dave Hansen <dave.hansen@intel.com>
Message-ID: <e33a2074-70b9-4671-e0f4-8b6402a426ff@intel.com>
Date:   Tue, 28 Dec 2021 15:34:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YcuX/DzVsAWvhEBA@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

>> +/*
>> + * Limits the amount of normal RAM that SGX can consume for EPC
>> + * overcommit to the total EPC pages * sgx_overcommit_percent / 100
>> + */
>> +static int sgx_overcommit_percent = 100;
>> +module_param_named(overcommit_percent, sgx_overcommit_percent, int, 0440);
>> +MODULE_PARM_DESC(overcommit_percent, "Percentage of overcommit of EPC pages.");
>> +
>> +/* The number of pages that can be allocated globally for backing storage. */
>> +static atomic_long_t sgx_nr_available_backing_pages;
>> +static bool sgx_disable_overcommit_tracking;
> 
> I don't like the use of word tracking as we already have ETRACK.

I don't think anyone is going to confuse "overcommit tracking" with ETRACK.

That said, this *could* be "sgx_disable_overcommit_limits", I guess.

> I'd also shorten the first global as "sgx_nr_backing_pages".
That means something different from the variable, though.

"sgx_nr_backing_pages" would be the name for the current number of
backing pages which currently exist.

> Couldn't you set "sgx_nr_backing_pages" to -1 when capping is disabled, and
> then you would not need that bool in the first place?
> 
>> +
>> +/**
>> + * sgx_charge_mem() - charge for a page used for backing storage
>> + *
> 
> Please remove this empty line:
> 
> https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt

That *might* make sense when there are arguments.  The arguments at
least help visually separate the short function description from the
full text description.


