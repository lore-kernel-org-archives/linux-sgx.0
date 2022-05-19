Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0413C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 19 May 2022 05:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiESFnT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 May 2022 01:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiESFnS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 19 May 2022 01:43:18 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD0D9D4FD
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 22:43:17 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 10so411319plj.0
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 22:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6z/Bc5UCAfAeTzRfuIMJWHJqH0NGV84MAGaXVzlC2gw=;
        b=iYklmhIxxcBAg2/vfEqx7EfCepTuDYi24pzQZ93iZPutwkc+6GNmiuWkRp4WSUW1ya
         f/jfz/Se1RPPSr78BVC2yxVHvo+u/ri3lBc67M9oXg9qkAJOo7O5E//zEJ2LbV1GkhZs
         CbBSsrRrh99IMN8FJB7Y+n1CoWRLQKbzzKDYetu4vJPPbfVNPn5PDJhiCjqFBIcV+jbY
         yjHTuITb9PGP6NBOf1aoOOfBWmJPl0/Ic4kCxNcIPALoEg9CwyWzGXEXerzi5uPx7nhX
         745qUbJI7IX6gxT3jJCXA77uajMX2tNeZM9/dGV9iA0ED0FTiHB3VKCFrrPZAFz/qG4V
         mtNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6z/Bc5UCAfAeTzRfuIMJWHJqH0NGV84MAGaXVzlC2gw=;
        b=EW4UDtSjD5sV4Z2WKEWqv03Y6A0WQCHv42jGuxCh8eQh6yZwpIdnhmLZYgvrTsHeWM
         sxwmWALbkctdezzo40uzW+fdTOztZ/MbEtMKVk1cjpOmBJ/FsjTOx1cN/LN4kSRyUhUk
         w/7xfmZrV04mnuChNBLkxPz3eL+pVhlJ5QLOZQZ1YIjRbFeSJ/H6sse8Es2LF4CjueY/
         YFJvnBJmRNDv15wLjGgEVUQ9zTMXWiSVhgEQ/6oElhM7vHV9Xrg6hS43MVO1V37YwbaJ
         l5EB4z/OWkO7bRDUnS2uA2r3YNIkRU7Pjr7nM3BV8i7H0HdMIJU5f3YCDKjd1De1NFfm
         rcOA==
X-Gm-Message-State: AOAM531OljPJn4oqJ/BxjhUniURkZCHvGtq6KTIPmM7PYXlqJDY6xdbZ
        IjDaKoSIu5nlnrk43tUSZIHuK3A45TyzEm4hkQa36W8jMTmqrw==
X-Google-Smtp-Source: ABdhPJwVrFgLJ/iOPmvarT2Xzx/jUomRSAH5rMsUBTKCfWAyxNrNKIq+GvtzXJtlJ8wYWG2H/jQ8POCBdgYFz8vIuXI=
X-Received: by 2002:a17:902:b094:b0:15c:dee8:74c8 with SMTP id
 p20-20020a170902b09400b0015cdee874c8mr3193505plr.6.1652938996847; Wed, 18 May
 2022 22:43:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220517164713.4610-1-kristen@linux.intel.com> <9c269c70-35fe-a1a4-34c9-b1e62ab3bb3b@intel.com>
In-Reply-To: <9c269c70-35fe-a1a4-34c9-b1e62ab3bb3b@intel.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 18 May 2022 22:43:05 -0700
Message-ID: <CALvZod40TpW0rX1jvj6GZWtr=nscJFkw_zdvZjbh7GPgd8pLWQ@mail.gmail.com>
Subject: Re: [PATCH] x86/sgx: Set active memcg prior to shmem allocation
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

(Fixing the CC list and sending again)

On Tue, May 17, 2022 at 09:47:13AM -0700, Kristen Carlson Accardi wrote:
>
[...]
> +int sgx_encl_alloc_backing(struct sgx_encl *encl, unsigned long page_index,
> +                        struct sgx_backing *backing)
> +{
> +     struct mem_cgroup *old_memcg;
> +     int ret;
> +
> +     old_memcg = sgx_encl_set_active_memcg(encl);

This function is leaking memcg reference. Please change
sgx_encl_set_active_memcg() to sgx_encl_get_mem_cgroup() or something
which will return the memcg with the refcount elevated. Then use
set_active_memcg(returned_memcg) here.

> +
> +     ret = sgx_encl_get_backing(encl, page_index, backing);
> +
> +     set_active_memcg(old_memcg);

mem_cgroup_put(returned_memcg) here.

> +
> +     return ret;
> +}
