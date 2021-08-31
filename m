Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC46DC4320A
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Aug 2021 07:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3FD6101B
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Aug 2021 07:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhHaHTF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Aug 2021 03:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239538AbhHaHTE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 31 Aug 2021 03:19:04 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58285C061575;
        Tue, 31 Aug 2021 00:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wMWQ7afJk2fnujuvLWw5x3JZCKsJTy9GBKnLegMd5ks=; b=bh695AvBuZ7M3JqiZMqx13Qs3o
        rhHwQEhwNin/3m2tn+IqkWl1VKimHyNGCd/IgqG5L3mavS0J8GIppQ3u4Bg1JyU09iPYM2rB7fk0f
        ZWo8hiFZ1Xt2SxIdEY2cNlBAD7RegoEAYm5+IUS4HcXfhP4v8/YpZ6hWFzVNmcfSRwE65qX85gDtK
        xXK6meiNNGDvu/RD9UVssjbBHHfTpqkgGsp62B0sgkxwufAj6BM7RAZzYRzlWGcppLRoH5CnsMk+D
        nNtR/tfV3L/VYlZvs00GMPBn/AJO0D/qLV8a2MQ5nanvOQFIRLTjim/sbGAThyJXtnXQ17l++sUNO
        vwGrX1Bg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKy1j-00EdRc-TQ; Tue, 31 Aug 2021 07:17:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8C0C73001F6;
        Tue, 31 Aug 2021 09:17:47 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7B4852CFB419C; Tue, 31 Aug 2021 09:17:47 +0200 (CEST)
Date:   Tue, 31 Aug 2021 09:17:47 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tianqiang Xu <skyele@sjtu.edu.cn>
Cc:     x86@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, kvm@vger.kernel.org, hpa@zytor.com,
        jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM host implementation
Message-ID: <YS3Xm9yEUO1DsR+G@hirez.programming.kicks-ass.net>
References: <20210831015919.13006-1-skyele@sjtu.edu.cn>
 <20210831015919.13006-3-skyele@sjtu.edu.cn>
 <YS3XOYJXcYw9vIda@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YS3XOYJXcYw9vIda@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 31, 2021 at 09:16:09AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 31, 2021 at 09:59:18AM +0800, Tianqiang Xu wrote:
> > @@ -4304,8 +4374,14 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  	idx = srcu_read_lock(&vcpu->kvm->srcu);
> >  	if (kvm_xen_msr_enabled(vcpu->kvm))
> >  		kvm_xen_runstate_set_preempted(vcpu);
> > -	else
> > +	else {
> >  		kvm_steal_time_set_preempted(vcpu);
> > +
> > +		if (get_cpu_nr_running(smp_processor_id()) <= 1)
> > +			kvm_steal_time_set_is_idle(vcpu);
> > +		else
> > +			kvm_steal_time_clear_is_idle(vcpu);
> > +	}
> >  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> 
> 
> This cannot be right. The CPU could long since be running tasks again,
> but as long as this vCPU crud doesn't run, the guest keeps thinking it's
> physically idle.

More fundamentally, a blocked task doesn't have a CPU. So unless you've
pinned your vCPU threads to physical CPUs, the whole thing is bonkers.
