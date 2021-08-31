Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10020C432BE
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Aug 2021 07:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E479460200
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Aug 2021 07:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbhHaHQK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Aug 2021 03:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbhHaHQJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 31 Aug 2021 03:16:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E25C061575;
        Tue, 31 Aug 2021 00:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YY9pvWpNs1TzAImK8Qk46A5Z5evWyYN+iUQ9FkXNB2c=; b=gZVCxgwskqclakQkAXx+Eg+7Bl
        l/BVBBomSXREZJyKAHP5/AUuxejcIaW95mP3JfuN25GssEJNYKjdO6Ud4u8HfgQ0cNSUk/PRERtsY
        hP/i6wVee6DIbIJPKXcY0nLdh9NNszNSK94qfHwz8VJMicVkUQmjB+Rk7Eb2PJzMc7MiqUXta/1O5
        xxYHMNCpBTCzXzexwKysuA4wAvsZsTrmkHLyyHK6XNKt047bIec6ihWXGJ8XZw1f0ZFCYrNaKwvU/
        eQVYRRaP1jAnA7umHS+h6y3brAhQ7KmMT4jieqDMs6dtybgjFdVWRKTTVbYb7La4nzKcgzw5H5Sbo
        d79TYnZw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKxyJ-00EdO7-8r; Tue, 31 Aug 2021 07:14:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6DAD23001F6;
        Tue, 31 Aug 2021 09:14:13 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 22AAB2CFB419C; Tue, 31 Aug 2021 09:14:13 +0200 (CEST)
Date:   Tue, 31 Aug 2021 09:14:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tianqiang Xu <skyele@sjtu.edu.cn>
Cc:     x86@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, kvm@vger.kernel.org, hpa@zytor.com,
        jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH 2/4] Scheduler changes
Message-ID: <YS3WxQe6bJLx6qpR@hirez.programming.kicks-ass.net>
References: <20210831015919.13006-1-skyele@sjtu.edu.cn>
 <20210831015919.13006-2-skyele@sjtu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831015919.13006-2-skyele@sjtu.edu.cn>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 31, 2021 at 09:59:17AM +0800, Tianqiang Xu wrote:
> Authors: Tianqiang Xu, Dingji Li, Zeyu Mi
> 	 Shanghai Jiao Tong University
> 
> Signed-off-by: Tianqiang Xu <skyele@sjtu.edu.cn>

Authors is not a valid tag, please see our Documentation on submitting
patches.

> @@ -10504,3 +10515,9 @@ void call_trace_sched_update_nr_running(struct rq *rq, int count)
>  {
>          trace_sched_update_nr_running_tp(rq, count);
>  }
> +
> +int get_cpu_nr_running(int cpu)
> +{
> +	return cpu_rq(cpu)->nr_running;
> +}
> +EXPORT_SYMBOL_GPL(get_cpu_nr_running);

Yeah, not going to happen.
