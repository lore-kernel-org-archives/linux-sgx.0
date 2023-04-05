Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEB9C77B60
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Apr 2023 14:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbjDEOzP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Apr 2023 10:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbjDEOzO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 5 Apr 2023 10:55:14 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D801F126
        for <linux-sgx@vger.kernel.org>; Wed,  5 Apr 2023 07:55:12 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-947a47eb908so55896966b.0
        for <linux-sgx@vger.kernel.org>; Wed, 05 Apr 2023 07:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680706511;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOaR+m1IdKafTORqEeSKI9ra6GC/lDyynNYDfbx3OGU=;
        b=VOcQEAwu5WIl2BXbkiz++NKRv+L2KBXjYnQVvHuoDd8AYVukZMZAp7Kh8e2RwoLTO6
         cOGPDQ+oJuNjOiImUXbZmozOYjQC5Pmo78cdP+qD8uAna23UHG4I4ZO0cW7zwr4ZeKau
         aHnRQL6kE7IfsbbjCxwiUTLPTY+vlPLfyqntA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680706511;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MOaR+m1IdKafTORqEeSKI9ra6GC/lDyynNYDfbx3OGU=;
        b=BWeHBhr8aLF+ErygcTkFWrKXIfHuCdLyLUw5kPgsLdyCvNsT0tOu5Pz21Hizkz9mBG
         ab+00KhIVyucxsCbcjFE0sVc7RGj+n5QR7DejA3SjGHE8hN39UQU5Hd6RGoIxNdAk6No
         ROWsG9VIa6Xpu08ceDQKMX8Ymf8DWQTwKwxF0AVLMex/kBcFwXv0WcWjf9oIA4s6QDfC
         Xg5qk77allkshxO9Td98RaS9vMdZ9iGg0xp93ExiDu4IDE6uyeJ0JU+CyiMoOhRp5hTQ
         SB+IVVarhhS5Pq0WYOM62WF9F32H1JK3zE1TlQS/GeW1MKP6nMDzbESf+tfpee7NpCHH
         koug==
X-Gm-Message-State: AAQBX9f0R8whzLfVp6k2uzW3k0Af3t0eomIuzH1bVMLAFxuGq4kS3YgH
        cTEiYVp8B1VX2FCZwifhFk3bYA==
X-Google-Smtp-Source: AKy350bSVmKQEeeS1X8+Q1+6RPrW42vDuHh4vOBA13B/ImZaryj0w4jta/xaGwUENLHN7VRkn928jQ==
X-Received: by 2002:a17:906:5195:b0:92c:fc0:b229 with SMTP id y21-20020a170906519500b0092c0fc0b229mr2784171ejk.0.1680706511286;
        Wed, 05 Apr 2023 07:55:11 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id ty25-20020a170907c71900b00948ca65d61fsm3581129ejc.140.2023.04.05.07.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 07:55:10 -0700 (PDT)
Date:   Wed, 5 Apr 2023 16:55:08 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Asahi Lina <lina@asahilina.net>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Karol Herbst <kherbst@redhat.com>,
        Ella Stanforth <ella@iglunix.org>,
        Faith Ekstrand <faith.ekstrand@collabora.com>,
        Mary <mary@mary.zone>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, rust-for-linux@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-sgx@vger.kernel.org, asahi@lists.linux.dev
Subject: Re: [PATCH RFC 13/18] drm/gem: Add a flag to control whether objects
 can be exported
Message-ID: <ZC2LzME5uHT3JDht@phenom.ffwll.local>
Mail-Followup-To: Asahi Lina <lina@asahilina.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Karol Herbst <kherbst@redhat.com>,
        Ella Stanforth <ella@iglunix.org>,
        Faith Ekstrand <faith.ekstrand@collabora.com>,
        Mary <mary@mary.zone>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, rust-for-linux@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-sgx@vger.kernel.org, asahi@lists.linux.dev
References: <20230307-rust-drm-v1-0-917ff5bc80a8@asahilina.net>
 <20230307-rust-drm-v1-13-917ff5bc80a8@asahilina.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307-rust-drm-v1-13-917ff5bc80a8@asahilina.net>
X-Operating-System: Linux phenom 6.1.0-7-amd64 
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 07, 2023 at 11:25:38PM +0900, Asahi Lina wrote:
> Drivers may want to support driver-private objects, which cannot be
> shared. This allows them to share a single lock and enables other
> optimizations.
> 
> Add an `exportable` field to drm_gem_object, which blocks PRIME export
> if set to false. It is initialized to true in
> drm_gem_private_object_init.
> 
> Signed-off-by: Asahi Lina <lina@asahilina.net>

Two comments on this:

- for kernel objects which userspace never access itself the usual
  approach is to simply not install a gem handle on that drm_file. If
  userspace doesn't even have a handle they also can't export it. I think
  that should take care of the kernel object case you have in the asahi
  driver.

- for the vm-private object case you need some more checks anyway, since
  you can't even use such objects on a different vm within the same
  drm_file. Maybe the gpuva helpers can eventually cover this, but in
  general these driver cases are handled by simply overwriting the
  ->export case, you can check there for vm_id.is_none() and if that's not
  the case, hand the actual exporting to the helper function.

  Whether this is done in the rust wrappers and you keep the
  set_exportable or just in asahi code is kinda meh, but personally for
  consistency I'd put that into asahi code. Imo it's much clearer when you
  explicitly list (by coding them into your export impl) the reasons why a
  buffer isn't exportable, instead of forcing people to chase
  set_exportable calls throughout the codebase. But also a bit matters of
  taste :-)

Either way (unless a missed a case) this should imo be handled in asahi
code and not in C or the rust glue.
-Daniel

> ---
>  drivers/gpu/drm/drm_gem.c   | 1 +
>  drivers/gpu/drm/drm_prime.c | 5 +++++
>  include/drm/drm_gem.h       | 8 ++++++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 7a3cb08dc942..152ad9295a8d 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -166,6 +166,7 @@ void drm_gem_private_object_init(struct drm_device *dev,
>  
>  	drm_vma_node_reset(&obj->vma_node);
>  	INIT_LIST_HEAD(&obj->lru_node);
> +	obj->exportable = true;
>  }
>  EXPORT_SYMBOL(drm_gem_private_object_init);
>  
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index f924b8b4ab6b..9d2dd982580e 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -391,6 +391,11 @@ static struct dma_buf *export_and_register_object(struct drm_device *dev,
>  		return dmabuf;
>  	}
>  
> +	if (!obj->exportable) {
> +		dmabuf = ERR_PTR(-EINVAL);
> +		return dmabuf;
> +	}
> +
>  	if (obj->funcs && obj->funcs->export)
>  		dmabuf = obj->funcs->export(obj, flags);
>  	else
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index 772a4adf5287..852dec3cf763 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -361,6 +361,14 @@ struct drm_gem_object {
>  	 * The current LRU list that the GEM object is on.
>  	 */
>  	struct drm_gem_lru *lru;
> +
> +	/**
> +	 * @exportable:
> +	 *
> +	 * Whether this GEM object can be exported via the drm_gem_object_funcs->export
> +	 * callback. Defaults to true.
> +	 */
> +	bool exportable;
>  };
>  
>  /**
> 
> -- 
> 2.35.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
