Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5994DC433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Sep 2021 11:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39E226101C
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Sep 2021 11:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbhIFLIw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Sep 2021 07:08:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240124AbhIFLIw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 6 Sep 2021 07:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630926467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZI1k/K6ivHiraxD4vMcL+vxFoqbnTrx2bG7F3rS0xHI=;
        b=Zt0hKJxDXmCPVV3PM0qovH9JNUMR0K7ePpbcEz2WBS2nvKqZNto7NbzXkGn/w6cqmMK96b
        sO6gchnPG56MFH6w0vEhjXDtVMs30IVZnvdowIDCR2RzmLQwAHSODZu7jItjWy2JPcsXDx
        1UnENrQHGSZqNz+faY6e9A7q5wa7LSs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-RlTD9LxIPXy06GQIqx-O7A-1; Mon, 06 Sep 2021 07:07:46 -0400
X-MC-Unique: RlTD9LxIPXy06GQIqx-O7A-1
Received: by mail-wm1-f71.google.com with SMTP id f19-20020a1c1f13000000b002e6bd83c344so3095680wmf.3
        for <linux-sgx@vger.kernel.org>; Mon, 06 Sep 2021 04:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZI1k/K6ivHiraxD4vMcL+vxFoqbnTrx2bG7F3rS0xHI=;
        b=dkcUMxNLOk+J90WgIV5GukLX9t20mZawCytx7Q2ujNeRs5Xwnbr6VLL4DkyCo0DEET
         O4bucJIWFhyB8aZ93ICIx2lFy0uC8z3beL0ANS2hWclYjRR/ZFSpiSlumfIrG9pjwZvi
         0ofMd2LmjIAVpk2iTylFtSWWJDW2XhDZ0eR866qgfF63H1S90LacS3mytbPMkWLKiLEM
         aW/VQxdBVAut+xNrM4m+9GFiXYBicTM4xAr17tSpgyh/TTIaDvY+aJxDtenf2DOM0a7l
         atB9ZOFnG6cgAZGLfAHi0qvVY4ZH/3mo05jfD2zdgPCfEkcV/pedu2BeT1jjmMtRxzyo
         Bn2A==
X-Gm-Message-State: AOAM532ywDrzwbA8fQD16Vc3djCczooIm6ac/1THYmrfZ55bCIG9S/8z
        61bGClHPchYQcyxPmnYZ0wMIqcMzVb0vc8gd81AWbKi++7RbZofiNzWi70yEfTHp/TCbTee7EYT
        T9mEbS2WKaZEoIJXQM3cw
X-Received: by 2002:a1c:f613:: with SMTP id w19mr10649235wmc.9.1630926465400;
        Mon, 06 Sep 2021 04:07:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSCaYJQUbwtbI35XMt6DrgI6FomYKM94zk2bKZi3g5Ujko33G2NGowArfIHSdln8gB0Uj/1g==
X-Received: by 2002:a1c:f613:: with SMTP id w19mr10649218wmc.9.1630926465210;
        Mon, 06 Sep 2021 04:07:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p3sm7429784wrx.82.2021.09.06.04.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 04:07:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jiang Jiasheng <jiasheng@iscas.ac.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/4] KVM: X86: Potential 'index out of range' bug
In-Reply-To: <YTI5SYVTJHiMdm+W@google.com>
References: <1630655700-798374-1-git-send-email-jiasheng@iscas.ac.cn>
 <87czppnasv.fsf@vitty.brq.redhat.com> <YTI5SYVTJHiMdm+W@google.com>
Date:   Mon, 06 Sep 2021 13:07:43 +0200
Message-ID: <87tuiy3qtc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=vkuznets@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Sep 03, 2021, Vitaly Kuznetsov wrote:
>> Jiang Jiasheng <jiasheng@iscas.ac.cn> writes:
>> 
>> > The kvm_get_vcpu() will call for the array_index_nospec()
>> > with the value of atomic_read(&(v->kvm)->online_vcpus) as size,
>> > and the value of constant '0' as index.
>> > If the size is also '0', it will be unreasonabe
>> > that the index is no less than the size.
>> >
>> 
>> Can this really happen?
>> 
>> 'online_vcpus' is never decreased, it is increased with every
>> kvm_vm_ioctl_create_vcpu() call when a new vCPU is created and is set to
>> 0 when all vCPUs are destroyed (kvm_free_vcpus()).
>> 
>> kvm_guest_time_update() takes a vcpu as a parameter, this means that at
>> least 1 vCPU is currently present so 'online_vcpus' just can't be zero.
>
> Agreed, but doing kvm_get_vcpu() is ugly and overkill.
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 86539c1686fa..cc1cb9a401cd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2969,7 +2969,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>                                        offsetof(struct compat_vcpu_info, time));
>         if (vcpu->xen.vcpu_time_info_set)
>                 kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> -       if (v == kvm_get_vcpu(v->kvm, 0))
> +       if (!kvm_vcpu_get_idx(v))

Do we really need to keep kvm_vcpu_get_idx() around though? It has only
3 users, all in arch/x86/kvm/hyperv.[ch], and the inline simpy returns
'vcpu->vcpu_idx'.

>                 kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>         return 0;
>  }
>

-- 
Vitaly

