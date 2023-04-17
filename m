Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6413DC77B72
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Apr 2023 11:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjDQLNx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Apr 2023 07:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjDQLNv (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 17 Apr 2023 07:13:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA80125
        for <linux-sgx@vger.kernel.org>; Mon, 17 Apr 2023 04:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681729809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lQP0jhHOILHGUYqqiFPFEP0oFPfgZ69ufmXe3pOVD4k=;
        b=Q+IiONeuiOrwTAepqyDJlsYuRKOqY0cvzTHrKMyfUQ0FLfOnrE0pzmNyZnv3tiVOmOUgwr
        xgTS0xgJK7njJkyeV1DDUrUuLEGGtyLHjP1AGfI4VIGbZ1pqgsofbINBc0PcUXhazs6jF/
        wc6/V+lYouKVhY3bPGH0yiaTEM2lcNU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-hZUCs_JuMW2oYdi83tJF1A-1; Mon, 17 Apr 2023 06:55:33 -0400
X-MC-Unique: hZUCs_JuMW2oYdi83tJF1A-1
Received: by mail-wm1-f69.google.com with SMTP id hg24-20020a05600c539800b003f066c0b044so16434898wmb.0
        for <linux-sgx@vger.kernel.org>; Mon, 17 Apr 2023 03:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681728932; x=1684320932;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lQP0jhHOILHGUYqqiFPFEP0oFPfgZ69ufmXe3pOVD4k=;
        b=bEmHIKu6ZvFTtR4m7tJbgjCB81hF77OIsU0pw6/qTrh9Eb3TFjMNh2k4FILhIscjMh
         3k7DdgIizqIyiRd/xJ/eKxNvkf+Est+zTSVdgwAjcZRLCnO4Gi82lmKWTknpyuOqrDPB
         O5JrhY2Q61Rxb0mhPaSyuS6TpRgLIQk9P6V6CRc/hpIm5ubrb0mfQqZt+7G5bfZtM3HV
         d9IbTYV5TdjyxrMGLyynWLYCieqCENae0FbNBL+4pyVZkN/y/ZJy3kXfqW5Fn4jvzOHV
         ryOI8KxWwT14gSeqv2aGz5fB+eKQRhvuqyJHN+VjXekD19ACMqYiMAIUb/mT+w1HKGDU
         qGYA==
X-Gm-Message-State: AAQBX9ekOtTiIMbVPBfm0o06Gd3g04A1MORuUCSoY9PTVZV+Bz+92mI8
        LGCxoZF4mkwEKOMvda2B2guc+Dsi8Eborpyj0dUTGdGxUNa1CYNZhpAc75BkX3JenrBev9x0j98
        GuhbYM/GdCObZL3/vTSnk
X-Received: by 2002:a05:600c:3793:b0:3f1:71b3:c6b5 with SMTP id o19-20020a05600c379300b003f171b3c6b5mr3472223wmr.26.1681728932429;
        Mon, 17 Apr 2023 03:55:32 -0700 (PDT)
X-Google-Smtp-Source: AKy350YH/86qIG88Tj0beqaD/3sOrt9ZF/SdVSy4Z1Oma4C+GIauFs3qJA38myjmhj9zrBrycpWLBQ==
X-Received: by 2002:a05:600c:3793:b0:3f1:71b3:c6b5 with SMTP id o19-20020a05600c379300b003f171b3c6b5mr3472203wmr.26.1681728932040;
        Mon, 17 Apr 2023 03:55:32 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:fc00:db07:68a9:6af5:ecdf? (p200300cbc700fc00db0768a96af5ecdf.dip0.t-ipconnect.de. [2003:cb:c700:fc00:db07:68a9:6af5:ecdf])
        by smtp.gmail.com with ESMTPSA id c10-20020a7bc2aa000000b003f0ad8d1c69sm10484005wmk.25.2023.04.17.03.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 03:55:31 -0700 (PDT)
Message-ID: <6ad9509c-11b6-9ada-0ee8-26cf40b3ac14@redhat.com>
Date:   Mon, 17 Apr 2023 12:55:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v3 1/7] mm/gup: remove unused vmas parameter from
 get_user_pages()
To:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Xinhui Pan <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <cover.1681558407.git.lstoakes@gmail.com>
 <28967f170eceeebf2591a5e4370d0642e0516f9b.1681558407.git.lstoakes@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <28967f170eceeebf2591a5e4370d0642e0516f9b.1681558407.git.lstoakes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 15.04.23 14:09, Lorenzo Stoakes wrote:
> No invocation of get_user_pages() uses the vmas parameter, so remove
> it.
> 
> The GUP API is confusing and caveated. Recent changes have done much to
> improve that, however there is more we can do. Exporting vmas is a prime
> target as the caller has to be extremely careful to preclude their use
> after the mmap_lock has expired or otherwise be left with dangling
> pointers.
> 
> Removing the vmas parameter focuses the GUP functions upon their primary
> purpose - pinning (and outputting) pages as well as performing the actions
> implied by the input flags.
> 
> This is part of a patch series aiming to remove the vmas parameter
> altogether.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

