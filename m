Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6D2C54EE9
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Sep 2022 21:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiIHVLA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Sep 2022 17:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiIHVK6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 8 Sep 2022 17:10:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1E8F56D4;
        Thu,  8 Sep 2022 14:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89354B822A4;
        Thu,  8 Sep 2022 21:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD580C433D6;
        Thu,  8 Sep 2022 21:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662671455;
        bh=faN35lg7Zhs0vKjQKFKiX5iUvRFc4abaKkEQ6BkSPn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NzwGh3dRiQZHUf+TjY8JrtJI70YebasyTtdGiP9AMPRYkRp5FxVIsd08nhRcBqQRQ
         p1HOrU4cEPmxtfi6EBzHVxUXDv482BM8uHka6y5YbOLtqBKafzsQ4dFhpo4DeNWgQq
         b2ePEsKy8NsELMt9avBiUh9d+ne+IAKcUm8TchFxg3Dv17MXEXMXgwUp3OGVCJYVvO
         +jXLn3bqvAW+nMa4BxhCsnQca6xgXArV08vUmo6+aj4o7RqegYc6Jzq5KGdaDAWB2j
         7SMUwhYGpgrbWrfeDFmcfyep2NClCsBoJeG1bUP1gb5wKnY7SjmAd96bqP/OZZ/AJI
         nyuVI8m4coozw==
Date:   Fri, 9 Sep 2022 00:10:48 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>, stable@vger.kernel.org,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] x86/sgx: Do not fail on incomplete sanitization
 on premature stop of ksgxd
Message-ID: <YxpaWMoeQS2ccwY8@kernel.org>
References: <20220906000221.34286-1-jarkko@kernel.org>
 <20220906000221.34286-2-jarkko@kernel.org>
 <c39e5088-b26e-b518-d7ec-3748f6bb76f7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c39e5088-b26e-b518-d7ec-3748f6bb76f7@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 08, 2022 at 12:53:55PM -0700, Reinette Chatre wrote:
> 
> 
> On 9/5/2022 5:02 PM, Jarkko Sakkinen wrote:
> > Unsanitized pages trigger WARN_ON() unconditionally, which can panic the
> > whole computer, if /proc/sys/kernel/panic_on_warn is set.
> > 
> > In sgx_init(), if misc_register() fails or misc_register() succeeds but
> > neither sgx_drv_init() nor sgx_vepc_init() succeeds, then ksgxd will be
> > prematurely stopped. This may leave unsanitized pages, which will result a
> > false warning.
> > 
> > Refine __sgx_sanitize_pages() to return:
> > 
> > 1. Zero when the sanitization process is complete or ksgxd has been
> >    requested to stop.
> > 2. The number of unsanitized pages otherwise.
> > 
> > Link: https://lore.kernel.org/linux-sgx/20220825051827.246698-1-jarkko@kernel.org/T/#u
> > Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
> > Cc: stable@vger.kernel.org # v5.13+
> > Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Thanks.

I also split down the long augment test also into pieces now,
as you requested, and I think it is now somewhat clean.

BR, Jarkko
