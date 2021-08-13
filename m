Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FD1C4338F
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Aug 2021 17:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C5AA6103A
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Aug 2021 17:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhHMRds (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 Aug 2021 13:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhHMRdq (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 13 Aug 2021 13:33:46 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EAAC0617AE
        for <linux-sgx@vger.kernel.org>; Fri, 13 Aug 2021 10:33:19 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id r19-20020a0568301353b029050aa53c3801so12911539otq.2
        for <linux-sgx@vger.kernel.org>; Fri, 13 Aug 2021 10:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T8OEJ0/DfNYzSKTeZkxD23Gy87W8zwO51wj73rgksrQ=;
        b=JESa9g5aaaaCF1y1elHvztrDLIciDsjdQt+82RK/MNFx9vn4u6mARLGlKteIl1i+lq
         UTpHZGJjiLGyFLJhseHG38lhqJmNpsLHXJwlxrh6zrM1OayUdIarDNjjDxSz8jxuq5hj
         rtOYQlO/YHqvTmAjgX8f0Tbwpxux4jeIe+3nA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T8OEJ0/DfNYzSKTeZkxD23Gy87W8zwO51wj73rgksrQ=;
        b=FUMuw4JkcVBhZSp6GgoqrU1C6Fj7seNHGtAweouCZsFno8mNRHPJksF9BcjXW3v3Rw
         3qnEI3P3VbvYLz6aqZipMYxFnybOJ+Rza81HAUFvzt9vZZ2vB7oHdBoW/7YgzY41Td9c
         cI78QzCTfESIrM+LkAODwK1HZmaOzPeKmeFqHhWFdTsSA6TabN5FtIwMKuKD9Q0KTocF
         aK4TqxKFYw522049oRF3wJH8pNCIecW67UbML5rwXifouxfY+s+ypgDTYnUn7COOTUuC
         Po0P4gW6XaSRxi8YFC8oQSTWVcXlWux9onWWX+NlUmFlDYPIHe7wafwua/zj567xkyiH
         uV+g==
X-Gm-Message-State: AOAM5336JT7zgv/YkAt38yrnNUg7qTom4PGBPFRy7efjmWFLqxhm2JQv
        5hDaBuDLccsJgMkdr8PfOi/oxw==
X-Google-Smtp-Source: ABdhPJwYke0vW2ZjfpTmneIbMUrd1MH8HL+Dglj/3ch/im2ZcLs194mx/BcIxtbq9/RbeuO0sdJMvQ==
X-Received: by 2002:a9d:887:: with SMTP id 7mr3013539otf.120.1628875998401;
        Fri, 13 Aug 2021 10:33:18 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j6sm386809ooj.11.2021.08.13.10.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 10:33:17 -0700 (PDT)
Subject: Re: [PATCH v4 1/8] x86/sgx: Add /sys/kernel/debug/x86/sgx_total_mem
To:     Jarkko Sakkinen <jarkko@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kselftest@vger.kernel.org, linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210809093127.76264-1-jarkko@kernel.org>
 <20210809093127.76264-2-jarkko@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4bcc069d-fafe-11e8-3fac-135e9ece2eec@linuxfoundation.org>
Date:   Fri, 13 Aug 2021 11:33:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210809093127.76264-2-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/9/21 3:31 AM, Jarkko Sakkinen wrote:
> Just like normal memory, SGX memory can be overcommitted.  SGX has its
> own reclaim mechanism which kicks in when physical SGX memory (Enclave
> Page Cache / EPC) is exhausted.  That reclaim mechanism is relatively
> rarely exercised and needs selftests to poke at it.
> 
> The amount of EPC on the system is determined by the BIOS and it varies
> wildly between systems.  It can be dozens of MB on desktops, or many GB
> on servers.
> 
> To run in a reasonable amount of time, the selftest needs to know how
> much EPC there is in the system.
> 
> Introduce a new debugfs file to export that information.
> 
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> 
> v3:
> * Describe the units of sgx_total_mem in Dcumentation/x86/sgx.rst.
> * Rewrite of the commit message (suggested by Dave):
>    https://lore.kernel.org/linux-sgx/5d3614af-2393-6744-9d85-7001241ca76e@intel.com/
> 
> v2:
> * sgx_nr_all_pages -> sgx_total_mem
> 
>   Documentation/x86/sgx.rst      |  6 ++++++
>   arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
>   2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> index dd0ac96ff9ef..f11bfb331b93 100644
> --- a/Documentation/x86/sgx.rst
> +++ b/Documentation/x86/sgx.rst
> @@ -250,3 +250,9 @@ user wants to deploy SGX applications both on the host and in guests
>   on the same machine, the user should reserve enough EPC (by taking out
>   total virtual EPC size of all SGX VMs from the physical EPC size) for
>   host SGX applications so they can run with acceptable performance.
> +
> +Debugging
> +=========
> +
> +*/sys/kernel/debug/x86/sgx_total_mem* contains an integer describing
> +the total SGX reserved memory in bytes, available in the system.

Why not add the details you have in the commit log to the document?
Also add more details on how to debug/test.

> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 63d3de02bbcc..b65da19a53ee 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -1,6 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*  Copyright(c) 2016-20 Intel Corporation. */
>   
> +#include <linux/debugfs.h>
>   #include <linux/file.h>
>   #include <linux/freezer.h>
>   #include <linux/highmem.h>
> @@ -28,7 +29,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
>   static LIST_HEAD(sgx_active_page_list);
>   static DEFINE_SPINLOCK(sgx_reclaimer_lock);
>   
> -/* The free page list lock protected variables prepend the lock. */
> +/* Total EPC memory available in bytes. */
> +static unsigned long sgx_total_mem;
> +
> +/* The number of free EPC pages in all nodes. */
>   static unsigned long sgx_nr_free_pages;
>   
>   /* Nodes with one or more EPC sections. */
> @@ -656,6 +660,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>   		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
>   	}
>   
> +	sgx_total_mem += nr_pages * PAGE_SIZE;
> +
>   	return true;
>   }
>   
> @@ -823,6 +829,8 @@ static int __init sgx_init(void)
>   	if (sgx_vepc_init() && ret)
>   		goto err_provision;
>   
> +	debugfs_create_ulong("sgx_total_mem", 0444, arch_debugfs_dir, &sgx_total_mem);
> +
>   	return 0;
>   
>   err_provision:
> 

thanks,
-- Shuah
