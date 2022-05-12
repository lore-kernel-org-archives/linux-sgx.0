Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCCEC433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 12 May 2022 14:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbiELOO0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 May 2022 10:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237439AbiELOOW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 12 May 2022 10:14:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE4A24EA09
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 07:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 225FAB8282E
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 14:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1526BC385B8;
        Thu, 12 May 2022 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652364858;
        bh=xaYaabUfzjs0lmYUirTcGKWoji0O2jfw71RrxijOUOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N8+g8YUpoFK6NmUm14L5itvnqLIUkCU9Z3KfcsAywmj00mzj+E2IwJUEODsT9rySo
         HMBOrB5JZ8KLxLkWORuwsye5iL6YzoAeEkilRmcsqrZp1cOScBIXgTxeSML+n4aMqG
         oq3o86LkGzr6A1fJq8T/Pmp6LHg/ur5Lclj8xXrI64bl7sxhJMLszoUArmfokHX4wh
         5nVqhYJiqFEn672ylN8ZdMcgbmy/J+RrMcqg1dfzZhUMnou3KCFF3QIEBk094j24+/
         kU3WVN6FeGrWJzu6g8rIhsnVNP5Sjfdd4q3ruxo0OszadTzWYGEQXhqF8KaePoWMrr
         q0oPgXUX7ytyQ==
Date:   Thu, 12 May 2022 17:15:56 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Subject: Re: [PATCH V2 2/5] x86/sgx: Mark PCMD page as dirty when modifying
 contents
Message-ID: <Yn0WnF1jrxXrOvUF@iki.fi>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <217608112793e76b335540edde75dfda290de16c.1652131695.git.reinette.chatre@intel.com>
 <YnuTYN/QZxoN53jc@kernel.org>
 <013b94d7-c7bb-1d13-94b6-24a6508b4bb2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <013b94d7-c7bb-1d13-94b6-24a6508b4bb2@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 11, 2022 at 11:01:50AM -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 5/11/2022 3:43 AM, Jarkko Sakkinen wrote:
> > On Mon, May 09, 2022 at 02:48:00PM -0700, Reinette Chatre wrote:
> >> Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
> >> after faulting the enclave page") expanded __sgx_encl_eldu()
> >> to clear an enclave page's PCMD (Paging Crypto MetaData)
> >> from the PCMD page in the backing store after the enclave
> >> page is restored to the enclave.
> >>
> >> Since the PCMD page in the backing store is modified the page
> >> should be marked as dirty to ensure the modified data is retained.
> >>
> >> Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
> >> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> >> ---
> >> Changes since RFC v1:
> >> - Do not set dirty bit on enclave page since it is not being
> >>   written to and always will be discarded.  (Dave)
> >>
> >>  arch/x86/kernel/cpu/sgx/encl.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> >> index 398695a20605..2521d64e8bcf 100644
> >> --- a/arch/x86/kernel/cpu/sgx/encl.c
> >> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> >> @@ -83,6 +83,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
> >>  		ret = -EFAULT;
> >>  	}
> >>  
> >> +	set_page_dirty(b.pcmd);
> >>  	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
> >>  
> >>  	/*
> >> -- 
> >> 2.25.1
> >>
> > 
> > LGTM.
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Thank you very much.
> 
> Based on my understanding of Dave's feedback I do plan to move the
> set_page_dirty() to be after the memset:
> https://lore.kernel.org/linux-sgx/8922e48f-6646-c7cc-6393-7c78dcf23d23@intel.com/
> 
> Reinette

You can keep my tag, I'll compare the patches and complain if there was
anything else done :-) Do not expect that though (at all).

BR, Jarkko
