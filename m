Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAA9EB64DD
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Jun 2023 14:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjF0O4A (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Jun 2023 10:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbjF0Ozg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 27 Jun 2023 10:55:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E7746BB;
        Tue, 27 Jun 2023 07:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687877677; x=1719413677;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ORxtrwZnKG+2aBbgd1b8Fxhy++nynEKa06ObBqJZo3M=;
  b=LqLu1hMKgBdFar0/G8rs0rtesw/ytQ29s7I8vlDAv9asJuDJLaUY+Nz5
   0xachyEwAzuNLnl98RsIayWdswX9tLxeoYlh+dtTWJ4QziS3N76meeML2
   LXFB7lOas6f0IxLrXVhfp51f+K73Or3MHJcUKZ+7xUwzUfjYry0SDH3WC
   dsVQzZEm9TBs+JLletYVGVg6dI3zBGvBFwTJ9u7mnZcFn4zZVSku38tUg
   yxPTB6ab//7nz8y7nUxwqV2M1/meG8B7OH9xj+QGib0gKDiMA6TUMLjh+
   DNP9NqcxA8jSen87w7ucZmRp24c3kVjQb+zbiIyFl4xjStp2LcGpzGtXM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="341179393"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="341179393"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 07:54:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="746249144"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="746249144"
Received: from btalbott-mobl.amr.corp.intel.com (HELO [10.212.238.85]) ([10.212.238.85])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 07:54:36 -0700
Message-ID: <004bc553-4dca-070b-c203-adcb50d4112d@intel.com>
Date:   Tue, 27 Jun 2023 07:54:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 21/24] x86/sgx: use vmalloc_array and vcalloc
Content-Language: en-US
To:     Julia Lawall <Julia.Lawall@inria.fr>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     kernel-janitors@vger.kernel.org, keescook@chromium.org,
        christophe.jaillet@wanadoo.fr, kuba@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230627144339.144478-1-Julia.Lawall@inria.fr>
 <20230627144339.144478-22-Julia.Lawall@inria.fr>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230627144339.144478-22-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/27/23 07:43, Julia Lawall wrote:
> Use vmalloc_array and vcalloc to protect against
> multiplication overflows.
...
> diff -u -p a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -628,7 +628,7 @@ static bool __init sgx_setup_epc_section
>  	if (!section->virt_addr)
>  		return false;
>  
> -	section->pages = vmalloc(nr_pages * sizeof(struct sgx_epc_page));
> +	section->pages = vmalloc_array(nr_pages, sizeof(struct sgx_epc_page));
>  	if (!section->pages) {

I'm not sure that changelog matches the code.

'nr_pages' here is an 'unsigned long' and The sizeof()==32.  In
practice, the multiplication can be done with a shift, and the ulong is
a *LONG* way from overflowing.

I'll accept that, as a general rule, vmalloc_array() is the preferred
form.  It's totally possible that someone could copy and paste the
nr_foo*sizeof(struct bar) code over to a place where nr_foo is a more
troublesome type.

But, if that's the true motivation, could we please say that in the
changelog?  As it stands, it's a bit silly to be talking about
multiplication overflows, unless I'm missing something totally obvious.
