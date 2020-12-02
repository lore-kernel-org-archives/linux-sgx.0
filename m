Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23465C64E7C
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 16:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2F0121D7A
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 16:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgLBQYe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Dec 2020 11:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730661AbgLBQYe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 2 Dec 2020 11:24:34 -0500
Date:   Wed, 2 Dec 2020 18:23:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606926233;
        bh=4AFGgJAxBySjo9NxfeSLO2HKDldWv32oYuKg2SCDKmU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=XxUyPM/wbfC3CJt1rV4UQuoyy8k8HhR3MY74RFucmU0keRMloO2FMQ5g+ZTuwo3hq
         kCgVaZROTUT6CpWgY4zj3SoUZdML9DVXG9vRlmIF76LLYH0LMMlPethrSTGRGHeC5Q
         q8cW50Ie6jp4e9fd6glibMZ/NwN7ggXiFdUyvTUw=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [bug report] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20201202162349.GB87890@kernel.org>
References: <X8ehQssnslm194ld@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8ehQssnslm194ld@mwanda>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 02, 2020 at 05:14:26PM +0300, Dan Carpenter wrote:
> Hello Jarkko Sakkinen,
> 
> The patch c6d26d370767: "x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES" from
> Nov 13, 2020, leads to the following static checker warning:
> 
> 	arch/x86/kernel/cpu/sgx/ioctl.c:466 sgx_ioc_enclave_add_pages()
> 	error: uninitialized symbol 'ret'.
> 
> arch/x86/kernel/cpu/sgx/ioctl.c
>    413  static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
>    414  {
>    415          struct sgx_enclave_add_pages add_arg;
>    416          struct sgx_secinfo secinfo;
>    417          unsigned long c;
>    418          int ret;
>    419  
>    420          if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
>    421              test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
>    422                  return -EINVAL;
>    423  
>    424          if (copy_from_user(&add_arg, arg, sizeof(add_arg)))
>    425                  return -EFAULT;
>    426  
>    427          if (!IS_ALIGNED(add_arg.offset, PAGE_SIZE) ||
>    428              !IS_ALIGNED(add_arg.src, PAGE_SIZE))
>    429                  return -EINVAL;
>    430  
>    431          if (add_arg.length & (PAGE_SIZE - 1))
>    432                  return -EINVAL;
>    433  
>    434          if (add_arg.offset + add_arg.length - PAGE_SIZE >= encl->size)
>    435                  return -EINVAL;
>    436  
>    437          if (copy_from_user(&secinfo, (void __user *)add_arg.secinfo,
>    438                             sizeof(secinfo)))
>    439                  return -EFAULT;
>    440  
>    441          if (sgx_validate_secinfo(&secinfo))
>    442                  return -EINVAL;
>    443  
>    444          for (c = 0 ; c < add_arg.length; c += PAGE_SIZE) {
> 
> If the user passes in an "add_arg.length" value of zero then "ret" isn't
> initialized.

Thanks, I submitted a fix:

https://lore.kernel.org/linux-sgx/20201202162200.88941-1-jarkko@kernel.org/

/Jarkko
