// Adapter example, NOT automatically connected to the published game.
// Pass an initialized @supabase/supabase-js v2 client. Never pass a secret/service-role key.
export function bodyArenaAccount(client, redirectUrl) {
  async function userId() {
    const { data, error } = await client.auth.getUser();
    if (error || !data.user) throw error || new Error('Bạn chưa đăng nhập.');
    return data.user.id;
  }
  function unwrap({data,error}) { if(error) throw error; return data; }
  return {
    async login() {
      return unwrap(await client.auth.signInWithOAuth({provider:'google',options:{redirectTo:redirectUrl}}));
    },
    async logout() { unwrap(await client.auth.signOut({scope:'local'})); },
    async load() {
      const id=await userId();
      const [profile,progress]=await Promise.all([
        client.from('body_arena_profiles').select('*').eq('user_id',id).maybeSingle(),
        client.from('body_arena_progress').select('*').eq('user_id',id).maybeSingle()
      ]);
      return {profile:unwrap(profile),progress:unwrap(progress)};
    },
    async saveProfile({nickname,selectedCharacter='mint',scale=100}) {
      const user_id=await userId();
      return unwrap(await client.from('body_arena_profiles').upsert({user_id,
        nickname:String(nickname||'Nhà thám hiểm').trim().slice(0,24),
        selected_character:selectedCharacter,character_scale:Math.round(scale)
      },{onConflict:'user_id'}).select().single());
    },
    async saveProgress(progress) {
      const user_id=await userId();
      // Explicit fields: no arbitrary client object spread or owner-ID assignment.
      const row={user_id,best_score:progress.bestScore,completed_runs:progress.completedRuns,
        highest_evolution:progress.highestEvolution,next_round:progress.nextRound,
        run_score:progress.runScore,run_evolution:progress.runEvolution,
        run_health:progress.runHealth,correct_answers:progress.correctAnswers,
        has_checkpoint:progress.hasCheckpoint};
      return unwrap(await client.from('body_arena_progress').upsert(row,{onConflict:'user_id'}).select().single());
    },
    async isAdmin() {
      const id=await userId();
      return !!unwrap(await client.from('body_arena_admins').select('user_id').eq('user_id',id).maybeSingle());
    },
    async characters() {
      return unwrap(await client.from('body_arena_characters').select('*').order('sort_order'));
    },
    async setCharacterEnabled(id,enabled) {
      return unwrap(await client.from('body_arena_characters').update({enabled:!!enabled}).eq('id',id).select().single());
    }
  };
}
