Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA046C678D5
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Mar 2023 15:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjCHPU6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Mar 2023 10:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjCHPUb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Mar 2023 10:20:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FD3CB65D
        for <linux-sgx@vger.kernel.org>; Wed,  8 Mar 2023 07:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678288776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZgwktT8M+kuZL3ds+rvp4biP/Gs8JikDQD7POfmJAag=;
        b=GE9eMPDRSHcHTPazoeplCgn7BIlUAkUlOaMRButkidIDZvAoO91eAnQK/rp3ohGen+Oqyt
        NtCIcqrSnJeNZWhADg+RJlY35UxPBlrDtwyg/ebmDsLxDHSNU4Aj0rD4yUvc6nKJlhF55F
        BM3vy0bNEDEtJNvKAGeWBnRt5mkhG+o=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-mzd3Y4r9NF2ARdcorSHrow-1; Wed, 08 Mar 2023 10:19:35 -0500
X-MC-Unique: mzd3Y4r9NF2ARdcorSHrow-1
Received: by mail-vs1-f69.google.com with SMTP id d5-20020a056102040500b004214c07da17so6066295vsq.0
        for <linux-sgx@vger.kernel.org>; Wed, 08 Mar 2023 07:19:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678288770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZgwktT8M+kuZL3ds+rvp4biP/Gs8JikDQD7POfmJAag=;
        b=S0+sACxM9QIAFn2XN0RZmZdDot8vu8IX4GtZFbzq+ICP0A7y2aenVH1j6Ulkg7OZso
         0j3pAChOYhOlfEC9lJLsCV4MjnrROoix8xzJfjIps2SYRE/lsPybCpH08Wl3sq9iD+ag
         nOoNdd12IWCjC6h+it37HQ7nFlfxAMbUiqswMT/cmy5UfznR3vlZeWT2wThwtx13/QDJ
         +X4PWsv5/FsEXMFdj+GhVYVxXfq/MVTUx5DaUxRbgik7Fa9CApdl7lqXcmhzFP2+unUx
         4oYqKgiyAz38kr6Qg/WYRXARQeKwPmPA13TblUNOSQXwGgBBdiLWCvIszgOisIztuHij
         xB0A==
X-Gm-Message-State: AO0yUKWki02W8HDHLNW61jV4+qgECp6E2mx3mepoVsc9yRD8G7CN6jm9
        mOpJyqdoEx8s8GfyJ2DqsLutfDqu655XdPyi7b3s1DY6m5wjG9pjOvMad1FEK9J7gRF+3ey0J07
        9q6Y1wABcKlQsycXdsqYS4JApawce9YIJueSi
X-Received: by 2002:a67:e94c:0:b0:421:c4a7:872b with SMTP id p12-20020a67e94c000000b00421c4a7872bmr9893513vso.6.1678288770286;
        Wed, 08 Mar 2023 07:19:30 -0800 (PST)
X-Google-Smtp-Source: AK7set+LFkvKeeVI3ttwm6kpFUQRkNGkfJ8qbDCG4jHcdwVIQ4SiuFcDQxKvoIfsyVYsxcEJcY4MnTcZLVjC63cvuTo=
X-Received: by 2002:a67:e94c:0:b0:421:c4a7:872b with SMTP id
 p12-20020a67e94c000000b00421c4a7872bmr9893505vso.6.1678288769989; Wed, 08 Mar
 2023 07:19:29 -0800 (PST)
MIME-Version: 1.0
References: <20230307-rust-drm-v1-0-917ff5bc80a8@asahilina.net>
 <20230307-rust-drm-v1-10-917ff5bc80a8@asahilina.net> <cd788ccf-0cf1-85d5-1bf8-efc259bd7e11@amd.com>
 <CACO55tsnCMQt8UW5_UCY139kpZOdNXbMkBkFfUiB12jW5UgVmA@mail.gmail.com>
 <0d6cd23b-8c9e-067d-97ff-aa35dbbcf9bf@amd.com> <CACO55tumNMYrcJ0LhnLfTK4DmGLHD-bt3xpXyoPe98V2wmgXQg@mail.gmail.com>
 <269c4fb7-60f6-6778-444d-15703febea58@amd.com>
In-Reply-To: <269c4fb7-60f6-6778-444d-15703febea58@amd.com>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Wed, 8 Mar 2023 16:19:17 +0100
Message-ID: <CACO55tuVVnC-_iVmX=SGGVF=0t6kqqr0Cy0pGe3YoppBgUbiXw@mail.gmail.com>
Subject: Re: [PATCH RFC 10/18] drm/scheduler: Add can_run_job callback
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     Asahi Lina <lina@asahilina.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Ella Stanforth <ella@iglunix.org>,
        Faith Ekstrand <faith.ekstrand@collabora.com>,
        Mary <mary@mary.zone>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, rust-for-linux@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-sgx@vger.kernel.org, asahi@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 8, 2023 at 4:09=E2=80=AFPM Christian K=C3=B6nig <christian.koen=
ig@amd.com> wrote:
>
> Am 08.03.23 um 15:43 schrieb Karol Herbst:
> > [SNIP]
> > "further"? There was no discussion at all,
>
> Yeah, well that is exactly what I wanted to archive.
>
> >   you just started off like
> > that. If you think somebody misses that connection, you can point out
> > to documentation/videos whatever so the contributor can understand
> > what's wrong with an approach. You did that, so that's fine. It's just
> > starting off _any_ discussion with a "Well complete NAK" is terrible
> > style. I'd feel uncomfortable if that happened to me and I'm sure
> > there are enough people like that that we should be more reasonable
> > with our replies. Just.. don't.
> >
> > We are all humans here and people react negatively to such things. And
> > if people do it on purpose it just makes it worse.
>
> I completely see your point, I just don't know how to improve it.
>
> I don't stop people like this because I want to make them uncomfortable
> but because I want to prevent further discussions on that topic.
>
> In other words how can I make people notice that this is something
> fundamental while still being polite?
>

I think a little improvement over this would be to at least wait a few
replies before resorting to those strong statements. Just before it
becomes a risk in just wasting time.

> >>>> This is clearly going against the idea of having jobs only depend on
> >>>> fences and nothing else which is mandatory for correct memory manage=
ment.
> >>>>
> >>> I'm sure it's all documented and there is a design document on how
> >>> things have to look like you can point out? Might help to get a bette=
r
> >>> understanding on how things should be.
> >> Yeah, that's the problematic part. We have documented this very
> >> extensively:
> >> https://www.kernel.org/doc/html/v5.9/driver-api/dma-buf.html#indefinit=
e-dma-fences
> >>
> >> And both Jason and Daniel gave talks about the underlying problem and
> > fyi:
> > s/Jason/Faith/g
>
> +1. I wasn't aware of that.
>
> >> try to come up with patches to raise warnings when that happens, but
> >> people still keep coming up with the same idea over and over again.
> >>
> > Yes, and we'll have to tell them over and over again. Nothing wrong
> > with that. That's just part of maintaining such a big subsystem. And
> > that's definitely not a valid reason to phrase things like above.
> >
> >> It's just that the technical relationship between preventing jobs from
> >> running and with that preventing dma_fences from signaling and the cor=
e
> >> memory management with page faults and shrinkers waiting for those
> >> fences is absolutely not obvious.
> >>
> >> We had at least 10 different teams from different companies falling in=
to
> >> the same trap already and either the patches were rejected of hand or
> >> had to painfully reverted or mitigated later on.
> >>
> > Sure, but that's just part of the job. And pointing out fundamental
> > mistakes early on is important, but the situation won't get any better
> > by being like that. Yes, we'll have to repeat the same words over and
> > over again, and yes that might be annoying, but that's just how it is.
>
> Well I have no problem explaining people why a solution doesn't work.
>
> But what usually happens is that people don't realize that they need to
> back of from a design and completely start over.
>
> Regards,
> Christian.
>
> >
> >> Regards,
> >> Christian.
> >>
> >>>> If the hw is busy with something you need to return the fence for th=
is
> >>>> from the prepare_job callback so that the scheduler can be notified =
when
> >>>> the hw is available again.
> >>>>
> >>>> Regards,
> >>>> Christian.
> >>>>
> >>>>> Signed-off-by: Asahi Lina <lina@asahilina.net>
> >>>>> ---
> >>>>>     drivers/gpu/drm/scheduler/sched_main.c | 10 ++++++++++
> >>>>>     include/drm/gpu_scheduler.h            |  8 ++++++++
> >>>>>     2 files changed, 18 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/d=
rm/scheduler/sched_main.c
> >>>>> index 4e6ad6e122bc..5c0add2c7546 100644
> >>>>> --- a/drivers/gpu/drm/scheduler/sched_main.c
> >>>>> +++ b/drivers/gpu/drm/scheduler/sched_main.c
> >>>>> @@ -1001,6 +1001,16 @@ static int drm_sched_main(void *param)
> >>>>>                 if (!entity)
> >>>>>                         continue;
> >>>>>
> >>>>> +             if (sched->ops->can_run_job) {
> >>>>> +                     sched_job =3D to_drm_sched_job(spsc_queue_pee=
k(&entity->job_queue));
> >>>>> +                     if (!sched_job) {
> >>>>> +                             complete_all(&entity->entity_idle);
> >>>>> +                             continue;
> >>>>> +                     }
> >>>>> +                     if (!sched->ops->can_run_job(sched_job))
> >>>>> +                             continue;
> >>>>> +             }
> >>>>> +
> >>>>>                 sched_job =3D drm_sched_entity_pop_job(entity);
> >>>>>
> >>>>>                 if (!sched_job) {
> >>>>> diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_schedule=
r.h
> >>>>> index 9db9e5e504ee..bd89ea9507b9 100644
> >>>>> --- a/include/drm/gpu_scheduler.h
> >>>>> +++ b/include/drm/gpu_scheduler.h
> >>>>> @@ -396,6 +396,14 @@ struct drm_sched_backend_ops {
> >>>>>         struct dma_fence *(*prepare_job)(struct drm_sched_job *sche=
d_job,
> >>>>>                                          struct drm_sched_entity *s=
_entity);
> >>>>>
> >>>>> +     /**
> >>>>> +      * @can_run_job: Called before job execution to check whether=
 the
> >>>>> +      * hardware is free enough to run the job.  This can be used =
to
> >>>>> +      * implement more complex hardware resource policies than the
> >>>>> +      * hw_submission limit.
> >>>>> +      */
> >>>>> +     bool (*can_run_job)(struct drm_sched_job *sched_job);
> >>>>> +
> >>>>>         /**
> >>>>>              * @run_job: Called to execute the job once all of the =
dependencies
> >>>>>              * have been resolved.  This may be called multiple tim=
es, if
> >>>>>
>

