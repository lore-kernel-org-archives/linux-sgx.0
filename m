Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D083AC433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Sep 2021 11:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6DC96108E
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Sep 2021 11:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348791AbhICLpW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Sep 2021 07:45:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348581AbhICLpU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 3 Sep 2021 07:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630669460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HpnKnHLGzPAJzdSBbsC3pLsaD4HC3lArEEuQ/lWlcJQ=;
        b=IeG+L9JMi1VdrHVbbN/ZiuERp+0L09BPOLAprxjOzlF8sP23qEWo7StkM4ZK0AEzVm+NHk
        2IOYxM8rrUiXBIQkP/sHdtUchji63tds/1skb/ezI1AJiE07NL1eVfqlQxz9s6qCxHqHNX
        TY32j7mnGCYYjkepsR4yJc38gMYDUOo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-MFlxU6FwN9aRJql-Vy3Syw-1; Fri, 03 Sep 2021 07:44:19 -0400
X-MC-Unique: MFlxU6FwN9aRJql-Vy3Syw-1
Received: by mail-wm1-f69.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so1859263wmr.9
        for <linux-sgx@vger.kernel.org>; Fri, 03 Sep 2021 04:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HpnKnHLGzPAJzdSBbsC3pLsaD4HC3lArEEuQ/lWlcJQ=;
        b=o8zeDfLsITvma5zg7AB7bauHNaN6hP13SwBF8qwggbtBRkpskOZbO6ITmLgVI44sEK
         cP/E3EBa/ftgqnneDZ6XTsA9ONWsY+lzuaOvl7bFoqQP31fkj1sxawc3YSLFfLn7HMx8
         0IT+p5U5GX8bQOCK7jgcnqlFih7WEmZJaHvPpxeL/wlCUzK9RMSu7xxrkKNdH0S+ACXf
         xQcBsu3ysIVXMosaYkKa4LDNScM9aTXb7GO7IdydyOSctwqKDk9ThSx4Y8uu6dC7Tas1
         OsYWQALxskc9MLg5xgSU3tXiZhG/FaVXQ6a8dGl/CPPdOX1/t2ndFFdG4W3tsojqkOUK
         c79g==
X-Gm-Message-State: AOAM531j5NNz2hLimS4+1gFS+DryDtxD62AFs9kcRQZ80Zkz1/sAACwS
        1GQ3WShF541d0DNUa9Yozf455sodBl4uIFBz+4939gYtpbgWBISsPzzv55KwLMLjx92Ye/xEQ/P
        69ggD5iqsuMVinT1aHDZw
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr7972766wmb.5.1630669458564;
        Fri, 03 Sep 2021 04:44:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9hLzrRRw3Zz73eixW1LRZLLtVB/uAe147wUhFALHXixvcPP///Nzyhh43bUtg7HVFfciNig==
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr7972738wmb.5.1630669458289;
        Fri, 03 Sep 2021 04:44:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u27sm4682490wru.2.2021.09.03.04.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 04:44:17 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jiang Jiasheng <jiasheng@iscas.ac.cn>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Jiang Jiasheng <jiasheng@iscas.ac.cn>,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        jarkko@kernel.org, dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/4] KVM: X86: Potential 'index out of range' bug
In-Reply-To: <1630655700-798374-1-git-send-email-jiasheng@iscas.ac.cn>
References: <1630655700-798374-1-git-send-email-jiasheng@iscas.ac.cn>
Date:   Fri, 03 Sep 2021 13:44:16 +0200
Message-ID: <87czppnasv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=vkuznets@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Jiang Jiasheng <jiasheng@iscas.ac.cn> writes:

> The kvm_get_vcpu() will call for the array_index_nospec()
> with the value of atomic_read(&(v->kvm)->online_vcpus) as size,
> and the value of constant '0' as index.
> If the size is also '0', it will be unreasonabe
> that the index is no less than the size.
>

Can this really happen?

'online_vcpus' is never decreased, it is increased with every
kvm_vm_ioctl_create_vcpu() call when a new vCPU is created and is set to
0 when all vCPUs are destroyed (kvm_free_vcpus()).

kvm_guest_time_update() takes a vcpu as a parameter, this means that at
least 1 vCPU is currently present so 'online_vcpus' just can't be zero.

> Signed-off-by: Jiang Jiasheng <jiasheng@iscas.ac.cn>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0f4a46..c59013c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2871,7 +2871,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  				       offsetof(struct compat_vcpu_info, time));
>  	if (vcpu->xen.vcpu_time_info_set)
>  		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> -	if (v == kvm_get_vcpu(v->kvm, 0))
> +	if (atomic_read(&(v->kvm)->online_vcpus) > 0 && v == kvm_get_vcpu(v->kvm, 0))
>  		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>  	return 0;
>  }

-- 
Vitaly

